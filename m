Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585946;
	b=WxrsgLoCDCuacm1aJ4NzCOV4YxfIhgTGt429XLsWfBVkKpUrSt5QkIuTaRK3XaNUNg5+
	 UEv8XnNI2J3a7F/kGw+lJ7tGyqEdTsB4Nm9L6HUf0ZOSxcxL2vSeo9r0eCfj2LkXfgqYH
	 +Ts6FOvLDSYpsrA3YkoEN5xrawqrvtG45Up0oj1we4DnWFKvvdIrgMFDvCBau4nsMmx0t
	 bbowQZto7Jl4kl1JwmNl57oL+8fXI/C76ESeuA1uy0OgZ6GbIXxHSspsVPrYlAwY0ruco
	 dKGSgf04gCfev4JOuMr/JbWi0mMegMKYABYP+0Pr04LbVXaH9b9bh6IjaZRTOjxQ7xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4l3tadcGKbVwNmpUoe6WY9HJTE0qLueRDYd8IHY25Z8=;
	b=EW3DLY3NlvzrCR56xAOuodnky0jNl4tKQHxuQ1C7nsBX9E8mBtjsy7zOuYddJEMSw3O8
	 aWPBB1o9Qk8jwzYyG9AppQlAUu1ZYEUg47y4irsJl8z4qWbDiLdY04H4DGH8cX0/TMEb7
	 +Zc/jEnXfJnRtdO5cn9+Y3zbvNbfPNjVywBO6vPib/nCwPBAobLugPHpnZiqkgV32ywtO
	 Nog8tKGTFOG67Wdzmh35CqDaYPvrt7PbiMOeNCSliaXgGaRDL6592YtlT/oyT3if0g+qG
	 5qdl6SgAIGjnUusRxZHTRMkse4e0ogCSkQBAfSX/NEc3JnFdpwsu14mYH+ZLoJEJtfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5Yo+RRT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DF86070FE4;
	Fri, 13 Nov 2026 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5Yo+RRT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BB01F000C4;
	Fri, 13 Nov 2026 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585946;
	bh=4l3tadcGKbVwNmpUoe6WY9HJTE0qLueRDYd8IHY25Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5Yo+RRTumuwOVv9Djza2jrdDKQubv3hPrHf9oAddIi8Bff1avIDnMqVAcCOmWGYx
	 AnwkvmARWXV3V6epitiCr1OO/XyfFMIPUgGTQnXhcGM8CIFzsbja/S6wAfwHkIdice
	 bQVxk7uZUljBEfG0zz0OfuI7pE92MHqR37Oezj60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charis Stratakis <c.stratakis@proton.me>,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Rong Zhang <i@rong.moe>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 500/507] thermal: intel: int340x: Evaluate _TMP exclusively
Date: Fri, 13 Nov 2026 10:53:24 -0500
Message-ID: <20261113153814.058577160@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

[ Upstream commit c4aae727beb23a736c15b8d53e219da29d791065 ]

On ThinkPad P1 Gen2 and P53, INT3403 _TMP switches the EC page selector
without taking the mutex the battery methods use, so it must not run
interleaved with them.

Evaluate _TMP with acpi_evaluate_integer_exclusive(), also where int3403
and processor_thermal probe for it.

Fixes: d33e89d12295 ("thermal: core: Suspend thermal zones later and resume them earlier")
Reported-by: Charis Stratakis <c.stratakis@proton.me>
Closes: https://lore.kernel.org/all/37N_jFulf7n-Z55NfKfE71C_wVPxYvZ0xD_iRUg2fXu7TypDiF5PStQ6siSfVBih6fThg5WoPes8U5ZQpfVm_teMFcUGXFxz2DdMbfSWuws=@proton.me/
Cc: All applicable <stable@vger.kernel.org> # 80892972ff23 ACPI: utils: Add exclusive AML evaluation helpers
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20261018122220.678822-4-aliamemis@disroot.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3403_thermal.c     | 3 +--
 .../thermal/intel/int340x_thermal/int340x_thermal_zone.c    | 6 +++++-
 .../intel/int340x_thermal/processor_thermal_device.c        | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
index 264c9bc8e6454..2262de1e14d95 100644
--- a/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3403_thermal.c
@@ -217,8 +217,7 @@ static int int3403_add(struct platform_device *pdev)
 	}
 
 
-	status = acpi_evaluate_integer(priv->adev->handle, "_TMP",
-				       NULL, &tmp);
+	status = acpi_evaluate_integer_exclusive(priv->adev->handle, "_TMP", NULL, &tmp);
 	if (ACPI_FAILURE(status)) {
 		status = acpi_evaluate_integer(priv->adev->handle, "PTYP",
 				       NULL, &priv->type);
diff --git a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
index 965700ee69626..9451fea1f65c7 100644
--- a/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
+++ b/drivers/thermal/intel/int340x_thermal/int340x_thermal_zone.c
@@ -18,7 +18,11 @@ static int int340x_thermal_get_zone_temp(struct thermal_zone_device *zone,
 	unsigned long long tmp;
 	acpi_status status;
 
-	status = acpi_evaluate_integer(d->adev->handle, "_TMP", NULL, &tmp);
+	/*
+	 * On some ThinkPads _TMP switches the EC page selector without
+	 * taking the mutex the battery methods use.
+	 */
+	status = acpi_evaluate_integer_exclusive(d->adev->handle, "_TMP", NULL, &tmp);
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index b0284c2e2e74d..9bdb65f54b6ae 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -287,7 +287,7 @@ int proc_thermal_add(struct device *dev, struct proc_thermal_device *proc_priv)
 	if (ret)
 		return ret;
 
-	status = acpi_evaluate_integer(adev->handle, "_TMP", NULL, &tmp);
+	status = acpi_evaluate_integer_exclusive(adev->handle, "_TMP", NULL, &tmp);
 	if (ACPI_FAILURE(status)) {
 		/* there is no _TMP method, add local method */
 		if (intel_tcc_get_tjmax(-1) > 0)
-- 
2.53.0



