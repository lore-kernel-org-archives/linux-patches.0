Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7105149C57;
	Mon, 16 Sep 2024 12:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488455; cv=none; b=Ke6wSpAFmcmflQDFNQ+OUyJjP6FuqNX+Jef2W3q2Dp8/VYymOHI2TUdEqdK38dSOapdHSsAK5e4u76Byw7OYRaHLRM6Fh3yFeSIJFGlGLhplZFGKr85OY+b277KYqGFnLUPoJXX5x0PsTFM9mxOrVbJbNNpbTtcBaX0uv9en5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488455; c=relaxed/simple;
	bh=nyehhbTS5i2ZGXw7NgQ8quPqnsKxnQ2YP13FZzRh97o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTDMvaoDJLFo6CQSiHGZ8yZHn2rkU0uHAtoO7HgaV5FVBL5LSMGCmYBPCeXkjWeNjNhGeBtmGPwS2w9ODolXJL0IFRWWsyo1uRgSwvASKWRAXX3b/u6Qy5L+WZUf/MGwf3K9nP9nUKeTv3/hbqoNuCZVx12cwsTBbPSJzwKYhNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZ54HKaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZ54HKaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50637C4CEC4;
	Mon, 16 Sep 2024 12:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488455;
	bh=nyehhbTS5i2ZGXw7NgQ8quPqnsKxnQ2YP13FZzRh97o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZ54HKaj+u6vtFow4IuooQ+zARmcF0GeNXPsTXd/NsUID3TbIPFtokmEIeoAwP3N4
	 V3nT4SdgengPCRdpVpi4Wvx9ix4YMffl+MwFC4ObOLn4gdt/TeRxh2mJ6CCprNwd40
	 0VqgzIq6UTh+rDKJy3F0JgWEX0Ty4rhr9hVEIzSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.10 119/121] pinctrl: meteorlake: Add Arrow Lake-H/U ACPI ID
Date: Mon, 16 Sep 2024 13:44:53 +0200
Message-ID: <20240916114233.056420729@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit a366e46da10d7bfa1a52c3bd31f342a3d0e8e7fe upstream.

Intel Arrow Lake-H/U has the same GPIO hardware than Meteor Lake-P but
the ACPI ID is different. Add this new ACPI ID to the list of supported
devices.

Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/intel/pinctrl-meteorlake.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pinctrl/intel/pinctrl-meteorlake.c
+++ b/drivers/pinctrl/intel/pinctrl-meteorlake.c
@@ -584,6 +584,7 @@ static const struct intel_pinctrl_soc_da
 };
 
 static const struct acpi_device_id mtl_pinctrl_acpi_match[] = {
+	{ "INTC105E", (kernel_ulong_t)&mtlp_soc_data },
 	{ "INTC1083", (kernel_ulong_t)&mtlp_soc_data },
 	{ "INTC1082", (kernel_ulong_t)&mtls_soc_data },
 	{ }


