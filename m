Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054762;
	b=E6tkVKnxjffkf+eZINb1HPV7fOtp8zeC1yvaOJwF1pJraISS5zXjzHbVcz67vbg/q9mO
	 Y50Jt+z2WaqL5luoVZEo19ntmYlEcTbmto9DyO1rg5QPSfYaxq1SW5s68irQOpnu669L/
	 /mcKVPm802N5emUkA/Mr4r0dey+OO8blYy89ctRGEPx+mJSIFfn0WFqN1D3hoQohB2UBP
	 GAVbLylZyxLYTVvscqVe+v0iN/eVyVnBve+Ml/CAdWkQFwWX+WOl4IaVHbFr/8BYThgYl
	 3L1Frngjw19d68/tzaZ5jDW6Eu5bOeXwofoX64s4ELghbwnT2Wr9ZNJkvbDL2deIQJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bVrSofbmIsVQqksx0DEYy8zfFrL1Z94Dvznia9acUMw=;
	b=IYtbHRkt2w8dcPInDoq97U8ZBADjEDAq0y0AeHviBLmTS/48ZPIuHunNKNpQ8IxOZBHr
	 LgiKms9ZY5W2jDXrugJ1UhaYV+ddL6PLHFkQHxDeyH7LswsfzJjTx3rgO42kUL+3aVLpo
	 N1jkwP+NIAwVQNggFsHxyyTkJ5VJzoGSKgyLWl0t4gt+cW3vrYkcFJJxc0X1A07Ri/hJ/
	 u4bcN7OPiyKo2F7bB6KtSwtvhSDrAWlQLTuIi41j3ZOj1EusYPE1wEJP0vF0ma4ArRGu0
	 us5A2fSz/27VJLdv+SyfGK9x168Mh5J4bh3wmZRQw8Us/lsvEijcnRNf6Iq0DANSsEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fupRWGQh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3C0606A320;
	Thu, 19 Nov 2026 02:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fupRWGQh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DB21F000C4;
	Thu, 19 Nov 2026 02:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054762;
	bh=bVrSofbmIsVQqksx0DEYy8zfFrL1Z94Dvznia9acUMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fupRWGQhLoq3urQOIcYYRM0E48K+2iMdaKyFeVE1x/c4E/SOdCPjU4ayMx6M9xV8/
	 Hu3sSLK3Ke8VzwYfYOj8Vim3Tko+zNEiG8PQM+oaU7PwNCAkvmNNz1hlIkE76ZGOCf
	 UebfgvK4h6Od7Orckp2G4I2IMm+EhO3e+4x8qaR4=
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
Subject: [PATCH 5.15 1391/2214] efi/cper: Read only validated fields in cper_mem_err_pack()
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150106.969014892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 057813687d14c..754aaca08da6b 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -360,10 +360,28 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
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
 
 const char *cper_mem_err_unpack(struct trace_seq *p,
-- 
2.53.0



