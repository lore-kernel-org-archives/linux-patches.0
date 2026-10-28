Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212846;
	b=yvkOSdkUxr2tlgE0MNfB+bw+T7XumUQkqyh/r6bpBbgcIkPayugFIRJERiWpysGUpgIx
	 zka1aN3SsJZPD4B01mVh3L0mvVO/HRnoF7bXcx9k9oFlH/D1/a7H7JHuhDBmsc8R1Cufk
	 SNyzsVQiLHpTr6B3EDv0JxWjEgSCMyZVeFoBPKJJIFoVNS/lTNyjfOrWnlflGEteDZViC
	 24X+O7BBTXraoh5nui7n/+XC3jvu9Nsq3sPOjxjonriYd/O6Rx8yk4lgERY5U20Ykwp1T
	 9DYIyYeMmy7lNelFFxFrVBlJ6o5KAbDpf2Jc9FbViYW6euYAr8WNPUYXnsN6mXUDs+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Y5v4mEzT1bJLa56xSbAZ39wKaiItmo2gdmEdH2s2Jk=;
	b=VIWX8mri0KDaT0Rqe4CV/sKR1I5OiAyfYfgmVPSTDxCbsjbwwjWo67P/TjL8z+HGHsFm
	 bvepvM9Jx6TxKFq0eGaWjbWmIOX5VhZsnk/TJRPgI6WAEYUqbvfXUwl3pAwzIrH09fL/7
	 40LqOPiipiXYBbOHCy/k89aPP2ghuLvuxloFCu22nYGNenFHk1JDQ0YmY4WjW9QKIs5yS
	 HYsDW9kBNPYis2ThjruQiM//d8sY1egKLy5i6FDwaJBIVrPd4x/nc3+sjPcaO6XkCo1Dy
	 e/zgG7KgPV/hKRBWbfQwy1WeM2si/+Cg90nbgm7Pw5iQMP4235mwftyaYNDaZWBtZEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcdNbzwY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A4C606A31A;
	Wed, 28 Oct 2026 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EcdNbzwY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BC61F01825;
	Wed, 28 Oct 2026 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212845;
	bh=/Y5v4mEzT1bJLa56xSbAZ39wKaiItmo2gdmEdH2s2Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcdNbzwYryyOC0Y+Tl1KjPG8a0f/R+uPQD57Vmx2ypFWPziJj7DLYWDcVXtKh8OXV
	 GvRWlcnWM0g2dnBYfR8lrxMEWEUv+qnCG5VkhzSZ9RKLDXw3u8FJSp/azhyvFaMIaX
	 L4U8bYRFVlFz9ebPbNmPjwAqjGRS17uWW+BWXmLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0254/1887] drm/radeon: Read the VRAM VBIOS signature with readb()
Date: Wed, 28 Oct 2026 17:39:10 +0100
Message-ID: <20261028170505.011005898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Imre Kaloz <kaloz@kernel.org>

commit de1eab13efef83fd2b76f4688de5bf672644596f upstream.

igp_read_bios_from_vram() checked bios[0]/bios[1] with a plain
__iomem load, which faults on sparc64 before the copy runs at all.
radeon_read_bios() already reads its two signature bytes with
readb() ahead of its own copy; use the same accessor here, keeping
the check before the allocation.

Fixes: b442962a9e82 ("drm/radeon/kms: add support for "Surround View"")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 09155b8932e5013dbce0f5cdff7d75264a279ee5)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -49,6 +49,7 @@
 static bool igp_read_bios_from_vram(struct radeon_device *rdev)
 {
 	uint8_t __iomem *bios;
+	uint8_t val1, val2;
 	resource_size_t vram_base;
 	resource_size_t size = 256 * 1024; /* ??? */
 
@@ -63,7 +64,10 @@ static bool igp_read_bios_from_vram(stru
 		return false;
 	}
 
-	if (size == 0 || bios[0] != 0x55 || bios[1] != 0xaa) {
+	val1 = readb(&bios[0]);
+	val2 = readb(&bios[1]);
+
+	if (size == 0 || val1 != 0x55 || val2 != 0xaa) {
 		iounmap(bios);
 		return false;
 	}


