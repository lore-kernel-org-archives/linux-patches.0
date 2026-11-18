Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029139;
	b=mJgPGtuHbfDHgivXWH0MdadsoqEKXtWlyLHO1nivpXT5C1aTWEmHBhAdQ6jxf0VD+6to
	 LsqSiG6BtFahUUoQBNh7ePMuuGAdSzyPqd6Mx4FElHH6Cl1px8c+1sPQw48u7P8T4Ssz1
	 SPxpIop5XdyMaVR3sHsDitl495h4Jvvf/c6LJZQrU+38cqHe6I9vduMxzgolP7aRR+EoC
	 E5euMlN/dFp/t+HyKyQz+33WzOOlDg4vgyB1PCPxxMo8i+t2G9tjcrWsI4VyHeNIEUidG
	 Wr2kB6/8Is/vmTJU1aU8VRNcavgYC07USdnInJSC5efqCvI4lBEwjS/8t0ThnIC3BQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1Y4RmSrJ/spyvqt7ypfPUxZAVMAYIENeLZe+Bh0xGKM=;
	b=RitFI1Wi27p4eZbg2PPlhew3nroeF0DEKf0Kaqw0yag4cE4VT128hr9Gb//RdqlUi0AR
	 vlJYGOXHvpT4p79h7f6ckvdoMHUob1e2ZkMJ4lbi8BGxwT5L2qtGHPScHM9A3f7LZwyHy
	 SyKpv50G/v5Cq5icpDH9xSK/f4nhaKki2Ole9jmKoYP6QwSxZMY/y/uCbjjR1Ue2sjKch
	 zgUlx/K+Uo0kzTByANtG9x34L5qHbSVO5PJylnpJHwnda0fMQIZIXiKxbh2ZeimZF7pEW
	 ne3eTHoMjAg2YVw5pWm0anYKeXZrgMrdNv5N98F3kRYYlwGiEHccBRDG41eI/9xHfYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdsUsrNs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B29606A31C;
	Wed, 18 Nov 2026 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zdsUsrNs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3991F000C6;
	Wed, 18 Nov 2026 19:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029139;
	bh=1Y4RmSrJ/spyvqt7ypfPUxZAVMAYIENeLZe+Bh0xGKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zdsUsrNsjqMmqSgn1w3rTQqTqEq7g23G3GX2O8qicZh2aLU81GqZHp7jAwKajpqgX
	 4m9bVcXuZP+zViH2k5HfvYmSUVNL1HZMnPO3LTYTG/8s1e0TGU2V8HTxE1NV0WMFu0
	 NjRZidHS5SGsJUHXGtMAwDVH5cMI+Ooj5HDuRIdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Hanjun Guo <guohanjun@huawei.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0243/1756] efi/cper: Read only validated fields in cper_mem_err_pack()
Date: Wed, 18 Nov 2026 15:39:30 +0100
Message-ID: <20261118150018.036336764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 92480a2b00a15b0add512b6fc474151ec5340a8e ]

cper_mem_err_pack() copies extended, rank, mem_array_handle and
mem_dev_handle unconditionally. Those live at offsets 73 to 79, past the
end of struct cper_sec_mem_err_old, the 73-byte UEFI 2.1/2.2 layout that
older firmware still emits and that cper_estatus_print_section() admits.
On such a record the copy reads up to seven bytes past the payload, and off
the end of the error status block when that section is the last one.

Copy each of the four only when its validation bit is set, and zero it
otherwise. Nothing is lost: a 2.1/2.2 record leaves those bits clear, and
every consumer of struct cper_mem_err_compact already gates the fields on
the same bits. Zeroing also stops callers reading them back out of the
uninitialised on-stack struct they pass in.

Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260714231835.303081-1-dave.jiang@intel.com?part=7
Fixes: 2dfb7d51a61d ("trace, RAS: Add eMCA trace event interface")
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260904172337.1409775-11-dave.jiang@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index f8c4866c480d9..292eda2077941 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -390,10 +390,28 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
 	cmem->requestor_id = mem->requestor_id;
 	cmem->responder_id = mem->responder_id;
 	cmem->target_id = mem->target_id;
-	cmem->extended = mem->extended;
-	cmem->rank = mem->rank;
-	cmem->mem_array_handle = mem->mem_array_handle;
-	cmem->mem_dev_handle = mem->mem_dev_handle;
+
+	/*
+	 * These four sit past the end of the UEFI 2.1/2.2 layout, which older
+	 * firmware still emits, so reading them unconditionally runs off a
+	 * short record. Every consumer of the compact record gates them on the
+	 * same validation bits, so leave them zero when firmware does not
+	 * claim them.
+	 */
+	cmem->extended = 0;
+	cmem->rank = 0;
+	cmem->mem_array_handle = 0;
+	cmem->mem_dev_handle = 0;
+
+	if (mem->validation_bits &
+	    (CPER_MEM_VALID_ROW_EXT | CPER_MEM_VALID_CHIP_ID))
+		cmem->extended = mem->extended;
+	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		cmem->rank = mem->rank;
+	if (mem->validation_bits & CPER_MEM_VALID_CARD_HANDLE)
+		cmem->mem_array_handle = mem->mem_array_handle;
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE)
+		cmem->mem_dev_handle = mem->mem_dev_handle;
 }
 EXPORT_SYMBOL_GPL(cper_mem_err_pack);
 
-- 
2.53.0



