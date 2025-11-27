Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4F93346AE;
	Thu, 27 Nov 2025 15:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255627; cv=none; b=apQeOqFjSY0kDOPu4NaPEQioIikJItMpal11/dBhBdLP7BoPLEoDu3FG5tO8/2D2AnSC1e8f2AuKImZ/hHRRKDX9LXaiWXN00umTZgIOJS5lvTO62fs8NfKcZ/AYpQii7QHsJa1gcgHFu+GL4pbNq5cyywiXbU6zg/UjuWVwU0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255627; c=relaxed/simple;
	bh=QIJvxbW4tRwZA6TqTzTFpV9l6C80UlgrHt2oCFrWKqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4uql/6UZi30M0yse2IZqLjRXu3gVUfzwnduQmSB5/u6e95wC1lWs4LkKPawZeHY4n01vsfLOz0kqOLqphU+/59nJX7cnrQNCmwIj9BUpC6ziHDy388rzf/4FYEW0+Sa/Shz4vtvt7lGUrr9yksvTG3Xrwklif1fwyGGHg87NnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnAvUAoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnAvUAoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F057BC4CEF8;
	Thu, 27 Nov 2025 15:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255627;
	bh=QIJvxbW4tRwZA6TqTzTFpV9l6C80UlgrHt2oCFrWKqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnAvUAoL8CRQ+SivjSF/XL9TVqrNoLYBPDBu2G5wYC5+TrHLxi+Q7LNZYQ3oFr8jw
	 2vaOR8AYnOkdauSc9bKeOV8J50k9i3GD08wIXwm4RQCumElwu5Oxgb0BDywcvOFSwN
	 YYw8o2BaBxmT/HpImHYw3/T1yudKkxnxFnw07o1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anthony Wong <anthony.wong@ubuntu.com>,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.17 057/175] platform/x86: alienware-wmi-wmax: Add AWCC support to Alienware 16 Aurora
Date: Thu, 27 Nov 2025 15:45:10 +0100
Message-ID: <20251127144045.048377016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Wong <anthony.wong@ubuntu.com>

commit 6f91ad24c6639220f2edb0ad8edb199b43cc3b22 upstream.

Add AWCC support to Alienware 16 Aurora

Cc: stable@vger.kernel.org
Signed-off-by: Anthony Wong <anthony.wong@ubuntu.com>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Link: https://patch.msgid.link/20251116185311.18074-1-anthony.wong@canonical.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/alienware-wmi-wmax.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/platform/x86/dell/alienware-wmi-wmax.c
+++ b/drivers/platform/x86/dell/alienware-wmi-wmax.c
@@ -90,6 +90,14 @@ static struct awcc_quirks empty_quirks;
 
 static const struct dmi_system_id awcc_dmi_table[] __initconst = {
 	{
+		.ident = "Alienware 16 Aurora",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware 16 Aurora"),
+		},
+		.driver_data = &g_series_quirks,
+	},
+	{
 		.ident = "Alienware Area-51m",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),


