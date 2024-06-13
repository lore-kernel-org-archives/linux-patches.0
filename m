Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25DD2F55;
	Thu, 13 Jun 2024 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282772; cv=none; b=Bm97YojbA1vjv2faPLyOOJ+GG2mfLToPb3kLQxXGvjvrqxzMnLJRTwU+1gvEB6D2jJDvLGbJ9zLJlg8Q9ncYBTjEZYFb78z62RYsYEUkHSQkLSAOcV8yaCOtJtQxUq5P3Iz4tLR9+CksX3sNiMT0/le7s7sILWVcEI/H1dWEQLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282772; c=relaxed/simple;
	bh=46FJehp5H7a7jl+FG0NiF9NEzI8F3ujSOA8qadkQHI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iO1MZL23GGiqAKP5z4zcROxJMqUl0Tu/52fXYhszlm1M+QenFeqluW1rbN1T5Ho6xC6Zr6GLKpBI0RwII8OJ+3R5dCb1Vc8qrhcpduqpQUJRQab503cq43kkAfKDEd4co6bufnfJrt/6bucft5tnBc0U+P1Y0wUtuCEuWCb5G6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NN4Ef5su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NN4Ef5su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABE4C2BBFC;
	Thu, 13 Jun 2024 12:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282772;
	bh=46FJehp5H7a7jl+FG0NiF9NEzI8F3ujSOA8qadkQHI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NN4Ef5su6Jjd5UPR1f4iyX2QoZmVjAkR0sYi68bM+hr4JVPk3FC8EU/XWzX/F81hH
	 XXsHPrQb+MFbKELoXMGVoQswKG5vreeZIM/NYhUwehAusTbFGAi+akSqDyEN6JVOxZ
	 /BFbSzx5nO7CxDFkUKDYVV51R33RJNX9Xs33To4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 383/402] intel_th: pci: Add Meteor Lake-S CPU support
Date: Thu, 13 Jun 2024 13:35:40 +0200
Message-ID: <20240613113317.083757884@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit a4f813c3ec9d1c32bc402becd1f011b3904dd699 upstream.

Add support for the Trace Hub in Meteor Lake-S CPU.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-15-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -290,6 +290,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S CPU */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xae24),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


