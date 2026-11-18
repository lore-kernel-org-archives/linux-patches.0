Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060349;
	b=piwvxKnEk/JYkgFGKiFsyuwaX3f0PO2PTXnqbaPrPwUWQHu7GZdPy0iqgl/owUfXn9YD
	 55NXtLL07vEq2E/O1Pj4oPr66gW4/9szEzNUd/cRyA0Hj/8KKGfdhXEhsqZN9dsOcwdYD
	 HIwMmk3u4DUYu3Y3SjOSek8ieeo5CGqvpMtFnPTlbwMJ82YK5T1tCNe8tr2KQ769xhb/r
	 fKLNVXCAJaMmtJuNLDjgOq4cdf+fcydQ3sTFGnAwyg9KJGttYYlF0bbF2HE6j1TMfLHyO
	 7eZrOl+6NjdIdTTzfqAQ5s1ZVifqg31A0B2AE76aLVaq0xYpRhM1DJquyfUnS9O7Abw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060349;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OQNGVLx8z7vLugjtX+hGA+T5ORGLsjsEnsjRJxsRmO0=;
	b=NSuLYb1OFu1K8QIpKswA3FtHuX+Vw8Wmng1WtdPLrs7TaMLrX+20t7OE2F9GGibp4a0U
	 oGYRRwqZy8ZGMJvY3jCU+P8x+rh51RSxWC3zOdcqI6TMSIegUN+9Dt8ETUABpyGYHYMQe
	 BVH1puhDk38wvA/670syL2EsibsYbcJJZ7ssufpxqqdma9Hzs7J/si/8u/QIKsyqnsWe9
	 PuSVbk3zF8fabWs1Sl5hF1OusUf02PGmHkKRFFJMB+DJCZdYvLI1vCS5uftDw3XqRY3uJ
	 TcfGvHVTLVqtjiL3mDXCv3mrXbH04CLRN3FOSb3Ae/7A1+5GOYSSmB0x0BeTSORMEMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqsj8cXM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00759606A326;
	Thu, 19 Nov 2026 03:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mqsj8cXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559E71F000C4;
	Thu, 19 Nov 2026 03:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060348;
	bh=OQNGVLx8z7vLugjtX+hGA+T5ORGLsjsEnsjRJxsRmO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqsj8cXM2pzJM4GfG5V1oPEnwai1NxR1Yx4/2H/6EMv69MmwBxIIkoY979+SJyshT
	 L2F6wum4V/ezyx/JfFfay/sp1QZBtwJVGeOYruKiWbEul7y4Fv2zwfXIvEf7maQyfu
	 8kTkQcG9+FC6KOXIh7Pud+dg3BRuhh3PFgjj8m/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1168/1848] efi: cper: check section header more appropriately
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150008.543629895@linuxfoundation.org>
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

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 1be72c8e0786727df375f11c8178ce7e65eea20e ]

When checking a generic status block, we iterate over all the generic data
blocks. The loop condition checks that the generic data block is valid.
Because the size of data blocks (excluding error data) may vary depending
on the revision and the revision is contained within the data block, we
should ensure that enough of the current data block is valid appropriately
for different revision.

Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Stable-dep-of: a5a612cd3eec ("efi/cper: Reject CPER records with an out-of-range error_data_length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index 2a51a072e6700..1de746fff20fa 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -699,7 +699,7 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
 	data_len = estatus->data_length;
 
 	apei_estatus_for_each_section(estatus, gdata) {
-		if (sizeof(struct acpi_hest_generic_data) > data_len)
+		if (acpi_hest_get_size(gdata) > data_len)
 			return -EINVAL;
 
 		record_size = acpi_hest_get_record_size(gdata);
-- 
2.53.0



