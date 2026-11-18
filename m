Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015527;
	b=uofxl1mdLo5W17UNOvt96Qr+tjLHpSjnGcqxpyzMcMy9g0AsAVxJkeoqIUWsfirsioGF
	 KaBa0CdUMvQg0XG+atTcyH8MEluhfl0hLxWsnLyyxuFfKGS9Da34tLNtnK3DnQBTG28UP
	 3wRXR9Anr5Dt2XJvnYT+taPcqkctTVtaWQ34NEevHBymWDI0MAul3vufrkKiCYlR5sMbW
	 vqe68NWZMDU+EWPiKKkYCYUvEKDeEst1VdglKw2aqBKBOX6rJTRWAi/ZDQe755pI9YNyc
	 tPiEGEAtot0/zxd2ZSetna3cUl4w3oKWohOdquTgSrUASbG+qtkMaajMLi8i55rAdGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oqALYKa243bM7M1MSY92BSsQzktvT+lUa+glPt8ytfc=;
	b=Hc7vnM8r4b8ws9ChFwUsPcnhLPjhXhuqsHNI6zm4lv8d8ZflwDTjKpKAg5Ajqza2cUFN
	 9a0kMNIUKPsxdFvnW1tSlVdVFLJKmsiFPkpfpCtEQA+aiiidS7yMZ9Cr3E05iMtm+L9Ys
	 Bfe2GkTUBLFwTKeFmNrZ3YGSN4i+FGQs3VCrDtyy4Rrj3lOMhI1LVW7sjPEKZinRueh/h
	 H9vLoNwjP/6ZFZJ76Z7Wb7b542mQNLPIg98WKNPZWqsPltUHaNnkJgAED/tVnE8/0rIDb
	 4qJc4RQsGsW8Jen/qX6u3J5CZg3J56DyhSGNLrFfNR9mxf3MTw8eogMyleRVaCxJN8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOUkirJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E960A381A;
	Wed, 18 Nov 2026 15:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aOUkirJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826B01F000C4;
	Wed, 18 Nov 2026 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015527;
	bh=oqALYKa243bM7M1MSY92BSsQzktvT+lUa+glPt8ytfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aOUkirJQWmMzPVr1/52KNGDTsG6sLdos8ubuPiai+7bqXAoYCWKt4z9YXPEY9rpfY
	 AZ7wQxBhmRb6x6PEcqGyBZLjWmBsiCiBiAq3NRctb31MNituzc4d1fugqb/BJL1q9T
	 ZFPE1Pl9DhMcYUxhDwwsxe/Rrsa2tNW7RLEnSgZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0164/2651] wifi: mm81x: free the firmware scratch buffer on parse failures
Date: Wed, 18 Nov 2026 15:23:24 +0100
Message-ID: <20261118150253.756972035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 87230a514d2ca128c3fcd96126bb18162459640f ]

mm81x_fw_load_fw() allocates fw_buf before it inspects the image, but
releases it only on the success path.  The two early returns taken for a
malformed image leave one firmware-sized allocation attached to the
device, and mm81x_fw_flash() retries the load three times.

Release it on those paths too, the way mm81x_fw_load_bcf() already does.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260812060740.1275280-2-lilinmao@kylinos.cn
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d6d2ad086c328..d407b57f4c9cb 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -117,13 +117,15 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 
 	if (mm81x_fw_get_header(fw->data, &ehdr)) {
 		dev_err(mors->dev, "Wrong file format");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_free;
 	}
 
 	if (mm81x_fw_get_section_header(fw->data, &ehdr, &sh_strtab,
 					ehdr.e_shstrndx)) {
 		dev_err(mors->dev, "Invalid firmware. Missing string table");
-		return -ENOENT;
+		ret = -ENOENT;
+		goto out_free;
 	}
 
 	sh_strs = (const char *)fw->data + sh_strtab.sh_offset;
@@ -179,6 +181,7 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 	if (ehdr.e_entry)
 		ret = mm81x_fw_set_boot_addr(mors, ehdr.e_entry);
 
+out_free:
 	devm_kfree(mors->dev, fw_buf);
 	return ret;
 }
-- 
2.53.0



