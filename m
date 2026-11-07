Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064631;
	b=YlNBnkJU8gQETfrgkwOmYcPhHpkNJeSPWvacIgsv1W/3UJdKr4BZFgkBmCh3kSgZ7mIP
	 eKEF5P9TFg3ggACuc+CnjkobDHvsAmV1BPVOyN+1hr4LO/L0g05InOxgm0XWAuBHZRFlF
	 tbQviSRttdlfq06odm8PKC3zhJ0V3nJLjB9Hp/HrJfIo3uQiU0kMmwLI4Slp3SErmijNO
	 pHowIm3HtgukWSBzcYRCXgSRwM/E7PClh+2unvs2JuWq4sQKaXG0fP25gNcHCH5gE1RXy
	 nq33siIy6BApXUzAydhQkk7CDAae0Nz/MxjUebog/xmu029mFCQ6G4uoYUJwC5sT33A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSNqtaRgB2eusCXYC/hPZtjrq6hYVrUaIfcOUWowvpk=;
	b=aALhrGR04z5zj8erzCl2ICg+ZVS+EMDo2NfXUe93VlpAFRU0yAJuXhCEra2IJiLx50we
	 EqFWRypPhK7bxHs8CL0HLSIFKR5rDLlFLThal6I0snqpQW8HRoxjDud8CIvzbxv9RYba/
	 5c0KrPSEBPI+svh2Dsq+d6AH/Tkl13TCLp7y5U0LLVNw1mSQZFaCqSL8QrXuA5N3mVCux
	 CaSv7vvHGfLSiJz80YrIwC1BdKrD1DD6I+9uGOdvFmIfuQeuz0UhQxQwnBvgsqC0y/q6r
	 XqNw9DnHNaCWHNoO1xwloEzg/9998XmsbnK5/ZVxpjX46kL6pkJ2CVYf97xpGjDyPaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgCbAyG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D259606A9E6;
	Sat,  7 Nov 2026 15:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dgCbAyG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F088F1F0089F;
	Sat,  7 Nov 2026 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064631;
	bh=gSNqtaRgB2eusCXYC/hPZtjrq6hYVrUaIfcOUWowvpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dgCbAyG6/9HIJlN8PL7PC3+9CN/uG5sBmPGYoSo+tYI9dm0nX0q6HJNxujt0Rd0XW
	 Vkh/n6Q8pmxHCPDMmd7oMncdxt7gTSOp7DUiPfnG5c0g5YOZvIIWgbIOyLrBG9qJma
	 Se6QX+0VT9dDm1G8MxtdUlOCo21Lp3fy1raICkhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0639/1257] dm-snapshot: fix crash if dm_io_client_create fails
Date: Sat,  7 Nov 2026 08:48:55 -0500
Message-ID: <20261107134956.928598800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 829c4d21148a205eca864429e06530319e1f92d5 ]

If dm_io_client_create() fails, it stores error into the ps->io_client
variable. The code would try to free it later with
dm_io_client_destroy(ps->io_client), causing an invalid pointer
dereference. Fix this by setting ps->io_client = NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap-persistent.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index e86d929b0e951..b587ee7330562 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -325,8 +325,11 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	}
 
 	ps->io_client = dm_io_client_create();
-	if (IS_ERR(ps->io_client))
-		return PTR_ERR(ps->io_client);
+	if (IS_ERR(ps->io_client)) {
+		r = PTR_ERR(ps->io_client);
+		ps->io_client = NULL;
+		return r;
+	}
 
 	r = alloc_area(ps);
 	if (r)
-- 
2.53.0



