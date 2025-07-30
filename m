Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29111E25E1;
	Wed, 30 Jul 2025 09:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869123; cv=none; b=Z90tfW8eHbbcLKLaNvcaO4RB7Xp7LlnuhR9ZntM/MxXZFTPdRE2hASMpm2Vb7W/AkVgJd6YsKgKCEBVbpA6aqEPlsyrYi6xWPO6TqsUKTgTnwswxDeo2tz/DpfK1guuwBW7DyaZDRoC92kMWpgAX0FhBCyWkTeXe/K4lN6sxZi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869123; c=relaxed/simple;
	bh=jHIbRkliXP0PxlE5xRMnYQFiV58XvLG/TgJ8qNmBN10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nwuN24I87GSkl9xz5KpcZwDTKMb7vGxpBdM28DelkuQc2X8osY5cme6bLy32q7m9sYhXR6MFWNVik1zuDvifwgpp36V049WJntMIGKTnSZ9jvutFjWVegRYM8v4lyUEEtBTe5WzdhJiNk5QRfWn+UZMSsi1xBaXDPhgJNACCTjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JS5OQtXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JS5OQtXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F18FC4CEF6;
	Wed, 30 Jul 2025 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869123;
	bh=jHIbRkliXP0PxlE5xRMnYQFiV58XvLG/TgJ8qNmBN10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JS5OQtXJXJthwvqoU6zFWGm51pCeBpdFm6vwr8FD0PDXaQ53NnM30HVdF5fzbHpXR
	 BaKC4mtq5SFOOOT/MsqEV21MkkTMHEQgJU+qszYDZFQB0xrIc1YpENhfPSPGiGqIU/
	 E/zjdwAHvZUGsN5ltb2DWl4I3Qz8DUlFvliymJag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.15 43/92] platform/x86: alienware-wmi-wmax: Fix `dmi_system_id` array
Date: Wed, 30 Jul 2025 11:35:51 +0200
Message-ID: <20250730093232.430845659@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

commit 8346c6af27f1c1410eb314f4be5875fdf1579a10 upstream.

Add missing empty member to `awcc_dmi_table`.

Cc: stable@vger.kernel.org
Fixes: 6d7f1b1a5db6 ("platform/x86: alienware-wmi: Split DMI table")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250707-dmi-fix-v1-1-6730835d824d@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -205,6 +205,7 @@ static const struct dmi_system_id awcc_d
 		},
 		.driver_data = &g_series_quirks,
 	},
+	{}
 };
 
 enum WMAX_THERMAL_INFORMATION_OPERATIONS {


