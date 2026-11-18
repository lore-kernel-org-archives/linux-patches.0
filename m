Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060362;
	b=ln4lNG0psd6teAB0fqDgJKqExR56smEaGdO4O6cjr0ofu67rBaYH8CfD/AgeR5Na8mOi
	 xd8QcYD+bKfvZwl4PqT+ykiTrr/WSHFLCWp8Ix/Xjj8kcDCN90wVp+snoduhEQReEdDxF
	 GP5plJX+/KrC+NjcRs/cJJxE/fyTGrmOutFODc8duy1Lk5oDLzTJpyWNKzWbYBX7JnHQc
	 RqZ3R/8k3GIY/a2fuazUpLsYQxg1vz0H4qXvawYKj7YzL4DOWxrMbcB1erUiyKGX6KSm9
	 3MGGVY3x23oJsQJGSdjEUgD4z7QrqiZIj+2vsfG6PA61OQnY3LKVnvwyY5phhBJ4sVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91WWvOXYAXU+rnx2q9VcRqUoi0OVcAFzhS8B6YcLqxs=;
	b=gCQGjr8vwLvJy1m4f31anvgtPr8QKIYogOfHWZN0OxDBh1r/zMtYv0o3yHpbe09SIiG1
	 yBV5AyIMO+H196r7BXq6UGAFv2yBOTVeejt4391ECp3UrKg765vhgiztEwq2Hijl79tAU
	 RUxq9cQwiHOPeee8kVtThzwiPE3KenupMZuhXRsEgs923SV5FjlMIehTQwYwlloRxqEWA
	 j09NxOs1+RN5lCScxm9D+5W95gzYWKr/bm3jFadJ9tM4hvxAQ5f28tUo+nw2G4CCg2qpE
	 W54hJ4YlL53HyukCgMbdqlbMJJZHxD6+yP3Gumx9X6Gh+YrscRphxeb6EwsKVPkKAWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jfrxlmcn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90C2606A325;
	Thu, 19 Nov 2026 03:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jfrxlmcn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4296D1F000C4;
	Thu, 19 Nov 2026 03:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060362;
	bh=91WWvOXYAXU+rnx2q9VcRqUoi0OVcAFzhS8B6YcLqxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfrxlmcnqL6OHsODv8LRENZaLqNufTwoXemcjVag5/jvXdmhbvm9HX5zRX0z9/Kyl
	 K0ZooX/OFao9d+NTU3/Kiolgtj5Xfqz/eFlSDxEAm3Q34q9ruhf5lHQXTldU+hPRU+
	 d8m+Wpaa3L2nUY8jEp070HlAngXq8low0nc+ZYKM=
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
Subject: [PATCH 5.10 1172/1848] efi/cper: Read only validated fields in cper_mem_err_pack()
Date: Wed, 18 Nov 2026 15:53:30 +0100
Message-ID: <20261118150008.683798816@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 44a4efbbf26b9..d188a69d4872e 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -361,10 +361,28 @@ void cper_mem_err_pack(const struct cper_sec_mem_err *mem,
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



