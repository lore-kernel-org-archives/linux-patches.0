Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023801;
	b=C7Rx1Rc3kCPJzBDIn0pxjKTnZIl2UKVBu7nORrgn5mS3K+QujefRdbKBWJX2FkECZPSX
	 LpEMbu8DGgs9NiSfrdbQ98Jv2mpB+dgPVcUYlbFZ74toeDFdYVEp+SvTg/hr2MVOFvQ5u
	 hkUfhLFpOGR+m4ZW4vYzupqv4rVulr2OyGQ6n/P//FEe6NKRHNKeZ63PrrrgpRNm4w1It
	 KbiYxCGzSipB4qQFfZ+HlXQZf1BgV6Rke2bw5wb9TWgMH3UaDsGJL7XUh8ZgajkUmaGJS
	 9i5X707KHRYZ09aqd31VipB6ZPd0/o4xrzv1VYOfpVRPQx6CvMAur/5kT+/fBHtje5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6v4yUP8aSKupMRan2rb51Dza9Ab7GSg77EnD+uPCqI=;
	b=26dsXKwttjs/8JbQv7M+hwiandBSlrIkXOVXyMa7ijkDPzUEC+zSBh/NnIbAC1W5xJbn
	 jsBdGBfj8USV9ZfKDR4njNdOKDxR9T/j64HNdzQOLx1T5+lmnXelk5QE8409dKBX617rm
	 fmjnDw2NsO6L+kHf4XddaP6G+n+sylxX89zeTPzcNAKhlzD2+elY+TgpkaTsJoLKopHfh
	 1Grq+/IEMZ8JhLML67Zo/gD5jfBXv3vE/tkATuDE9ulVgI9z71gYqJa4OMZJDFqGdKV+8
	 gR6WGw9Sw1PjpP0YngvO6r2bldL4rCJwrabov4GGJfYLCOy0Jwp+DzUDgOzfi4eSuoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNDrz8dN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE695606A32A;
	Wed, 18 Nov 2026 17:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zNDrz8dN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398EB1F000C5;
	Wed, 18 Nov 2026 17:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023801;
	bh=M6v4yUP8aSKupMRan2rb51Dza9Ab7GSg77EnD+uPCqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNDrz8dNhwFE0D/QXV9M60rp5pP7xjXCDLhSunPGiWS8KZqYZqf/vHvsiDMb8Mlf6
	 j0QBilv0soeHdOeqGIIVTEy4/gHjMVYHlPmrVcH4OQGqpr5EkgQz3KG5K+GAv11Ssg
	 qTBeTGJrair69fjEvnyyqSYIHWiRmHlkSX8JZEOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0499/2151] ata: sata_dwc_460ex: Dont enable interrupt if libATA core registration fails
Date: Wed, 18 Nov 2026 15:37:14 +0100
Message-ID: <20261118150140.229516299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Borisov <nik.borisov@suse.com>

[ Upstream commit e137035fcd66cb454c479bb989968561bbc60341 ]

Recent 4bbc16a353a9 commit changed the timing when interrupts are
enabled. However it didn't account for the libATA registration step. So
it's possible that interrupts are enabled when the device is not
registered with libATA core.

Resolve the issue by failing the entire registration process in case of
failure to register with libATA.

Fixes: 4bbc16a353a9 ("ata: sata_dwc_460ex: enable SATA interrupts only after IRQ handler is registered")
Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20260917150707.1643330-1-nik.borisov@suse.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 36cc28b898650..02c2eacba82fb 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1184,11 +1184,14 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	 * error_handler() to execute a dummy Softreset EH session
 	 */
 	err = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
-	if (err)
+	if (err) {
 		dev_err(dev, "failed to activate host");
+		goto error_out;
+	}
 
 	/* Enable SATA Interrupts */
 	sata_dwc_enable_interrupts(hsdev);
+
 	return 0;
 
 error_out:
-- 
2.53.0



