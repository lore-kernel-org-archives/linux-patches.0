Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2FF145FFF;
	Thu, 13 Jun 2024 12:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280201; cv=none; b=mQw7gUJieT8JRGQza1yTRFprGQtYpFPBDOKMRMSm4V6mdMdMTwXwKJm1K+8C7396EATASMTRtpmhmhJIbgPWchQ9aoG592/2cQYLyTAM2l9xkNphoVdzWiEr/ZY+LKwZUHE2wy2ZO0guJU8Ei09I+l0RdVuoiqY/LxG/3MkaxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280201; c=relaxed/simple;
	bh=MlTPTMdraLUIk5YbovSuFavKSGyHXmQbNffl9w7L5bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEyIMzvJpZ0iMnvK7cmOg0piVprs6plDBF2mo5zF9MVRMHgK3Z32k2pKhjHzlNno7k6ITJ/oqoDza5k+uxyc5fJJrepuLlY+tRokiGFhcnXrK1xGc0hyStRhp+CeQl4QccKG8GePTu1QXDhrPRdvPpS+m1WGWYcFXhVqrE/L0xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hybCKOoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hybCKOoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9936EC2BBFC;
	Thu, 13 Jun 2024 12:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280201;
	bh=MlTPTMdraLUIk5YbovSuFavKSGyHXmQbNffl9w7L5bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hybCKOojtVPN2+oeyY8Be9BcWmSDtAtOBjSRb1Y4vDeWUY7mKFVMVhCZZcixW//GC
	 Rxi27EvnH29NrRqbNR/7ynB3LMM2jWfiGiS14QFpHDM12ShQkAs0YhiH851a7k77k0
	 mv4mp3tNGAnELNV/M6/6qJMi5ix44e7Y+eH6lDkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 176/202] ACPI: resource: Do IRQ override on TongFang GXxHRXx and GMxHGxx
Date: Thu, 13 Jun 2024 13:34:34 +0200
Message-ID: <20240613113234.532253950@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit c81bf14f9db68311c2e75428eea070d97d603975 upstream.

Listed devices need the override for the keyboard to work.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -475,6 +475,18 @@ static const struct dmi_system_id asus_l
 			DMI_MATCH(DMI_BOARD_NAME, "B2502CBA"),
 		},
 	},
+	{
+		/* TongFang GXxHRXx/TUXEDO InfinityBook Pro Gen9 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
+	{
+		/* TongFang GMxHGxx/TUXEDO Stellaris Slim Gen1 AMD */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GMxHGxx"),
+		},
+	},
 	{ }
 };
 


