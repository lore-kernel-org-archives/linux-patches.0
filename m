Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F061C07E5;
	Tue, 15 Oct 2024 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997640; cv=none; b=Jwr2Nk23beaNosu9zqU3SiD8402Ux5N+oFaRkwqrSVSNfM2XxgU/0c73tV3DSPQU4Q8LoHx8gadQKPyfsV/zuEVzLYUag2b7fHN8Irp6UJTR1nvTqyDGyr8YBnpyfn1DpCtt6y7guMA3T05NxlKCjzc3SV5e7bSYSvzQK9jfqs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997640; c=relaxed/simple;
	bh=VywtIFR/u86ERdT7pSpmTpvuSLfTPT+J3qZWPqpip+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fw0LTa5GWFCIkVYT/7lgwh1d3dfuYcYFVYM8OiNAhUVxczYJH8HIDCESbtXLQjxBiMorRs/vcVumnmiC5uELcHqSWk5nuH4M0o6YJGFCqVZ7PoCMB5CfxpfWzvNFz0aEg//mW5S2q8hi8DEqriKLcu85yXHGjuETADk3yD8FdtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpn9t/E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpn9t/E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C683C4CEC6;
	Tue, 15 Oct 2024 13:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997640;
	bh=VywtIFR/u86ERdT7pSpmTpvuSLfTPT+J3qZWPqpip+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xpn9t/E7NP3xqaf7T9VWd+gK1HWZc5m1zvn2SWhO8oDCs+f5avTDQY6codWRJBxJn
	 DA8QgKGGT3/p2+6yrVBW5hNaOzvwPzIJAApWlCVuLibtlEiYHQu0ixPRhBzE4fvJoE
	 /Kcrd3u4UlpS8VSpFJsqdVrrQaXIsyge1xPoa0ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 234/518] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Tue, 15 Oct 2024 14:42:18 +0200
Message-ID: <20241015123926.022846599@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit a98cfe6ff15b62f94a44d565607a16771c847bc6 upstream.

Internal documentation suggest that the TUXEDO Polaris 15 Gen5 AMD might
have GMxXGxX as the board name instead of GMxXGxx.

Adding both to be on the safe side.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240910094008.1601230-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -456,6 +456,12 @@ static const struct dmi_system_id asus_l
 		},
 	},
 	{
+		/* TongFang GMxXGxX/TUXEDO Polaris 15 Gen5 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxXGxX"),
+		},
+	},
+	{
 		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),


