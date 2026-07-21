Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98F746EF64;
	Tue, 21 Jul 2026 18:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659001; cv=none; b=rZkH6YGPqy8I0VMGqZba30jtRaK525bCUhUwr7IswnlWp4AKdDVs5oOCwNhm+oRBjh+bmwyAXumqriETo85IGpAlKFZCdqKJmpuchztuei5XavrHRiUiBhEfp7l2XYw2CnG7EnmHmF6UP6I/Dv++rTMm0kx/VK+kpXhuXACGbhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659001; c=relaxed/simple;
	bh=czTSY6i/q+5vJES7z0pkHxp7jeQUFqsNXdQWQdc+rME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5NVXbVmBqWsOUgUde0EsC8Pl9kowg53WICnlEChrpDqbO3NWKkIcordm2P71YNw61ObOa9RLY2POuUH/haWOdGta8/0PzmK/1qQjCyPHr4sHXgwCaWRNn+HC2V17eLSrnLd80ZydPJZWbVL5NWrhIEHloVBygXotupNztMU3l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUjKGfWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUjKGfWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F78B1F000E9;
	Tue, 21 Jul 2026 18:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659000;
	bh=Ef+G0uoDMn/NPyVbjy6JRrwhyXMvSnDU4gONwnbE7Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUjKGfWHRO5FT0W7wKsRP+7UnzHAyMlsPJ1/Uw/kYWGzaPEd7y5IFEkR87JJcisPo
	 CxPxuMDi/uh88qlB9z9yfcC/QQHFk2d8CKuTF/WPAHvbSwv6ivcJYFGN7dZrD+tBXC
	 l29rdiioO3IXUIvql2hBioStWY8J5lUek9zF03DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1357/1611] dm-integrity: dont increment hash_offset twice
Date: Tue, 21 Jul 2026 17:24:33 +0200
Message-ID: <20260721152545.978723582@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit edf025f083854f80032b73a1aad69a3c90db236f upstream.

hash_offset is already incremented in the loop "for (i = 0; i < to_copy;
i++, ts--)". Do not increment it again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: 84597a44a9d8 ("dm-integrity: dm integrity: add optional discard support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1479,9 +1479,6 @@ thorough_test:
 			*metadata_offset = 0;
 		}
 
-		if (unlikely(!is_power_of_2(ic->tag_size)))
-			hash_offset = (hash_offset + to_copy) % ic->tag_size;
-
 		total_size -= to_copy;
 	} while (unlikely(total_size));
 


