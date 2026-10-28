Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213468;
	b=w8KWLK8pIvAxCars1VYhAC+vILiA1Ga90W1n5t/xGRzIvypBSK8R95ygOKXacHiJO2SV
	 9pnBK6oeqsBGeB0FpAaS6EUuy8oroSIK9NAwSoyWfs9VBsOWscP7zbg1OIwbYZoJzZLre
	 mWWL6FNfND/tu+6L+bf7nrLCraSCcLOBjwf84soKkfMDavE/oX1AGNf2MFY7obvZw/e62
	 +sC6NJxrdlMdFcgVMnB1kSFS3F18LUf0CLu+N8tosnm/c/o2zDKksyKBgCD7cut1PkLJf
	 cJw4Jw8OotCizEzl/K6ZzMdaWo8KRJUpZp6OVEep5zzClJr9t9YBqjAfnmPwiQxEs1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HOE/SemSK95goGs/ISkHbr+d/PXaH/0NIwHDmknMyCk=;
	b=26uvTzV/RgG+vR/31efkiuRxoztmlIZxXjL60ZTFb9BajOGqWckdpWNDRyYT8Ds396UX
	 kuPqSy2SM8c8cueayM7/FQcp6KgFptMr0UTRUWOx+tSOfGukv0PdyGjRmwaVJv2YNigUX
	 3WxmQFPANhbQL4BMdMElAvGoPDRUpiz/JUn3OCkmLYRYgK9svUcsNOVZ2b0Bmh2mSXrdR
	 NVzobE3o/UyDC55Es+fHZ4TbSw2Ymww3FCZohpV0RJQpI32iUfsUWgqofeFJ40Yb9OUGn
	 wC5L0CTUHf4/KSqKR3aVE4hFiKy/0pp+yreN4qdRbbrN5kvkG6YRjWc639Atmo7MgiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbIvfHBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD15606A31F;
	Wed, 28 Oct 2026 18:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbIvfHBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE0E1F01825;
	Wed, 28 Oct 2026 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213467;
	bh=HOE/SemSK95goGs/ISkHbr+d/PXaH/0NIwHDmknMyCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbIvfHBj4WI3rQRK2M37Pm5WUz1zOpqMfgwbh4GO18FwyhqpLkgsGkUuUZ08KHuNp
	 eFEWwjktoqg83wXim/kQcV1Cl0H0JrOjbLgGFFyAcHOFz3YhW8AXaBvg/stR5dt1Kp
	 tQ/K4wwVoPoXotnXJrtXIVt6wt7fVHcYy54IpmsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Vishal Badole <Vishal.Badole@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0515/1887] EDAC/amd64: Mask UMC chip select to the four implemented selects
Date: Wed, 28 Oct 2026 17:43:31 +0100
Message-ID: <20261028170511.036568016@linuxfoundation.org>
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

From: Vishal Badole <Vishal.Badole@amd.com>

[ Upstream commit 7484bc43ba6b8e189b482db5b75e7842890a82b1 ]

For DRAM ECC errors, the chip select value can be found in the
MCA_SYND[ErrorInformation] field.

ErrorInformation[2:0] was first documented in Zen1. The 3 bit field
implied that up to 8 chip selects may be used.

However, all Zen-based systems have only ever had up to 4 chip selects.
So only bits [1:0] would contain a valid chip select value.

Future systems are redefining the field to ErrorInformation[1:0]. This
matches the existing 'up to 4 chip selects' implementations. And it
frees up the extra bit for other decoding.

Change the current chip select mask from 0x7 to 0x3 to prepare for the
decode change.

Fixes: 713ad54675fd ("EDAC, amd64: Define and register UMC error decode function")
Suggested-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Vishal Badole <Vishal.Badole@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20261002113204.3358815-2-Vishal.Badole@amd.com
[ sashal: Applied the change in decode_umc_error() instead of the absent umc_get_err_info() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/amd64_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 2f854feeeb237..7b3d3615de5cd 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3300,7 +3300,7 @@ static void decode_umc_error(int node_id, struct mce *m)
 			err.err_code = ERR_CHANNEL;
 	}
 
-	err.csrow = m->synd & 0x7;
+	err.csrow = m->synd & 0x3;
 
 	if (umc_normaddr_to_sysaddr(m->addr, pvt->mc_node_id, err.channel, &sys_addr)) {
 		err.err_code = ERR_NORM_ADDR;
-- 
2.53.0



