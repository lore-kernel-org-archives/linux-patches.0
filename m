Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0271BD00C;
	Tue, 11 Mar 2025 15:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706287; cv=none; b=LqZN4zYgKTdfvsU9Q78y0kVyIf8i32uDqNOfkumsOB4+u2RoKhudaQq/+klJ6kUqbnTTkhTIU/GYIo+owv0Mso2GGnzBUPOGiOxlAlMoj3VjCgIhiY6WCbErFopuw8Ob67GrIHRCYKbwlvVs8f+j0ahLthEL9qLxHzPF+gKEZ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706287; c=relaxed/simple;
	bh=SlWavOBjSgmSxGUesfdUTTZJwfKiWPSMhibcKnSSQbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knmT4N2cU3SEsYBZoyjggSz3ePzzkLXkKLquxSfgypL7ee9pfadbMG7uALCuMlGGKY+HNAoYvaCw1PEod81cFANKgfFpUh7gx1MHUgSdxcbYUon9AODcmi4MT9EvtgRlF1BjfObXdCXhTmp7AGTAQXoyKwjJWveBzMWZ/Q0kGmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZSS0/lr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZSS0/lr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C53DC4CEE9;
	Tue, 11 Mar 2025 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706286;
	bh=SlWavOBjSgmSxGUesfdUTTZJwfKiWPSMhibcKnSSQbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZSS0/lrNuU1qCEijWfX6746csQqY82aJ8L6TqAMc89WxiVLuzbdC6SSmze4aG2iX
	 2AUrmz2mQHp1Om2T6sAiO8TxIG5cPDAAWMtFjjUIsVDJ+Ln84++eN2Ae1AcCze9fIk
	 if5Wan874KwX4Az6oA6yLbKsJZ8/llbhE7VS5cFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 326/328] intel_th: pci: Add Panther Lake-P/U support
Date: Tue, 11 Mar 2025 16:01:36 +0100
Message-ID: <20250311145727.853967951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit 49114ff05770264ae233f50023fc64a719a9dcf9 upstream.

Add support for the Trace Hub in Panther Lake-P/U.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -335,6 +335,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Panther Lake-P/U */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe424),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


