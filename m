Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A213A27E;
	Wed,  3 Jul 2024 11:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005583; cv=none; b=lSUoYJedc4iSN9vLThLkoU+XxidZQjyvEg8ItZYNIdXJTXGWuuCX8qn8ertM6Ljen99VO77RtufDiQjjBIuFHYvSAuC3P8cJRHmbxrq6y52PAMukDqBKPTq4EqxVmJD9ezXxTT1GSTk7UysYS8PtASdYzGXQjvWcIKqDiHoxlL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005583; c=relaxed/simple;
	bh=BC/p8zZzAm9Q2CmXVNoNGIOoiuq+s7pRJHF7LbWWBqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmY5fRrnuwHA+tiERPgcsxjjBVchb3ybbsAydgcWny6WhsBmoziuVUHoccs8Ux9xVJXX6ziDgIOnTHXzH1FQHaLUk+l6YfCQFo7W1+1QXk8EUMpINw1KANF4yqlbbGksCtgnst16w/igFsTlmrMUteBvnuWWaTLe5Z9REwnYXM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mHAIM/Lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mHAIM/Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88170C32781;
	Wed,  3 Jul 2024 11:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005582;
	bh=BC/p8zZzAm9Q2CmXVNoNGIOoiuq+s7pRJHF7LbWWBqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mHAIM/LmSL/AePWUIJjBzzQsh86vQxjQHBVyf5Lz+w7P314QqY0qY/Hy2wRfbTUmO
	 QQUIqvy7zniwnlhFzMfALMT2N1gJ041GOUvg7PDIPSFMrZUE8lgmh1aYd2EGJf8znF
	 QxpgT9kvi0jldOLa/UsNEZU2gGkiv6gud3qOGuNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 129/356] intel_th: pci: Add Granite Rapids support
Date: Wed,  3 Jul 2024 12:37:45 +0200
Message-ID: <20240703102917.980125917@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

commit e44937889bdf4ecd1f0c25762b7226406b9b7a69 upstream.

Add support for the Trace Hub in Granite Rapids.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-11-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -305,6 +305,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0963),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


