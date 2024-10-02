Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B681CF5FB;
	Wed,  2 Oct 2024 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876921; cv=none; b=aLBnNrqaRzL27Pj9WAjKr6THpIXd4/ZkOqq7iG/IdpmcRMaEIVlnIJu/GQgSP7VpspaK2K+kfaXHi0RJC96gZA2XnN28LqxzJzGWKV5ThmeFUja6I6SzVft6AD+AUC+9hVpwE0scFrdy9HzCbdicmW1i0rERKv8oG3ddQBSBg+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876921; c=relaxed/simple;
	bh=Gzi+sNbXPO/m1BPg7lb4MAAuX4g9uZfjzFzTtRXMv8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suSMrD3bKQV8WtHeOgyKKBKSh8niOLI4XDQ7KOM8jZ6IPt+sqxsPpQZjPv3BgTF6Dpz8CboKMwHX+rOzkIdSWEJEwN7htCtsq3iUFynP8Sb/Hp/g+Tx91Z1QvuntpzVnEgMPo2O3xieyB/H+qXmBTjqsYcFnppLbwkL76iESKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjvapyIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjvapyIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ECBC4CEC2;
	Wed,  2 Oct 2024 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876921;
	bh=Gzi+sNbXPO/m1BPg7lb4MAAuX4g9uZfjzFzTtRXMv8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjvapyItOuv1Z45NDWXru81VtVYODYZfRw0BFsfX31sHA4nBLBM3C8PDN28b4jyS2
	 vLgkVCQIBldxWwtdXLeAm++1fX5TIkwYHmGYmwlB3VbwRrRgSmt6y3TEgT301N3OX2
	 Acu7wvDEWH/+gp9gdPPVbNOLSEsFgpvYRhHWbjJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.11 606/695] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Wed,  2 Oct 2024 15:00:04 +0200
Message-ID: <20241002125846.703570291@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -579,6 +579,12 @@ static const struct dmi_system_id irq1_e
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


