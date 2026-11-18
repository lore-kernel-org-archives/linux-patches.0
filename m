Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048484;
	b=ozzQETyMjhOXWYB3+AXeG4DHpWelPHSOoKUfpRc95vhNZSxOJfMQEFkNwI+WOLBedLDS
	 SZQh6V2cgjsiEmp+HuRvUfeuFze5sXQLjNQJyqNJpQBI/oKPX4j2BmlX8SQY227FKkkn/
	 f7bcvY0CWoggigKdsk3CXWIvQVJUHgajQEjnd6ckkkZuvv6dB/YgHlZ3tyf6ki9plP0hZ
	 l7ZKwaqMynF1qTlNrHc6kSKm+NHbk4YFtK8yUNeNgSkKXYdvnz4+HP9phICzItEwYPl3h
	 z+LZaI6LY83zcDeFZjyO3O/iiA/eMckfpMYwsFe6EoYTEIM/9yb66xOu0tiC8bGR/DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4fiwyLKAzXgt/DemeFmJeKVjHgESuI1jWNRgGbFRMKw=;
	b=brEuS6+1MfPTYT1cneDesPnVyW2p10MYFVbFTaM+U3s3LKIkpPFiOSiE70vfG4IyUlWq
	 lXQ+o0RV6CMLk2oD4Mvp8eAogx6/a/IrVpejQr4EoUxE99VzVLkEhBcnxtmz/sVbjnZ+q
	 4UbDkX9CR+Ch1CVCQI6B1Up8Ib6LdNMzxaCRSjUQrv5nEbZZtU7UWsJtJrYKynenTC5hm
	 /53nZoD8I8t4PhypJPBtapFaN22MRaTDKDWPLaZbd8qP5TaCNgKw5KXX0QKDxx2hg6uoe
	 yA8TKZ2sQTdUlVPFEK8O4Z6HJJ2OopmE0zjselb3F7RscaXBX9qrmayeN3Za66jORuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMZusFiA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F87606A31C;
	Thu, 19 Nov 2026 00:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wMZusFiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E1E1F000C4;
	Thu, 19 Nov 2026 00:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048484;
	bh=4fiwyLKAzXgt/DemeFmJeKVjHgESuI1jWNRgGbFRMKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMZusFiAjBWEZGS0aS+LIWvlLhFIfrEab+qyaSzJiCupVeEVdJTuhGXk+ld4Kl8WY
	 hJROWp0cfqvdu9+nQjGwxVIILVpuzWL0t7SFRSFjTwfD2+livToFz2oOcuQ1/HVayN
	 RVeRUH0QNuvWDJewCAikmIpLtJy8N2JNmA8CRe3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2011/2857] swim: Select appropriate drive once only
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150313.808170141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit a2d22b3f25c388f9fbce7bf36a45a8900dce4aa3 ]

Before turning off the spindle motor, call swim_drive() to select the
appropriate drive. Remove the swim_drive() call from swim_add_floppy()
because it was already called by swim_floppy_init().

Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/370f73fcceb53ce4860904ce6cf4f06ade0e43d5.1788513996.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index c82447a4656b2..fd050d06ad3c0 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -681,8 +681,10 @@ static void floppy_release(struct gendisk *disk, fmode_t mode)
 	else if (fs->ref_count > 0)
 		--fs->ref_count;
 
-	if (fs->ref_count == 0)
+	if (fs->ref_count == 0) {
+		swim_drive(base, fs->location);
 		swim_motor(base, OFF);
+	}
 	mutex_unlock(&swim_mutex);
 }
 
@@ -754,8 +756,6 @@ static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 
 	fs->location = location;
 
-	swim_drive(base, location);
-
 	swim_motor(base, OFF);
 
 	fs->type = HD_MEDIA;
-- 
2.53.0



