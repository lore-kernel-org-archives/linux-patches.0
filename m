Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7D299AB5;
	Tue,  2 Sep 2025 13:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820146; cv=none; b=tIkMMQvkckfemux6x0PhpyEwSqJYgx1YrkPyQHejjLsLJUnrwq4WlSDPCCp8F5TFwQo+SIMBAqRuRE8i6PuSWXPPNSf6CG0OiXQGWKHRnYbIcXFy1ORz58/OK5XmPYpns3+sfzAiDUTZMSFFIxieDZxntjoeKpcdjsW66dmNK4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820146; c=relaxed/simple;
	bh=0XWgP0W0LgO7qbvMFjk0NWGznccESwnJdLsW+UR74xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kevszN+BnmyBTMTy7XBxTlIJRRAbcKhW9xIy3iQ0fLCtadQvdcWHZWlbXVSuumbhUFEIYPa4ui1AzGlDPGuDbJbJaL5iTb2EgAZ/IbZmUjSzNC0Fx65+9M4fQjy5akpJj48Ile3NEIVm4D8pktXsFMAkkxfyri7dMB5FMztrDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRmzTWgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRmzTWgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682ABC4CEED;
	Tue,  2 Sep 2025 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820145;
	bh=0XWgP0W0LgO7qbvMFjk0NWGznccESwnJdLsW+UR74xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRmzTWgq2qHhCo3aLr5mDaHd1+qYj5knywt7UK4hlHB53ORV2zvUZTdEAOuHctg+D
	 D0Ctm48zgacbjSDL/FHlRQIs3to3PqYYSAfOQbUWwnVG1vAJ4yxPQSLChbW8ivFF48
	 nQsu7WC7vNNhKlZp8L9GEul1kP3UnGumbBFspzso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 13/75] ACPI: EC: Add device to acpi_ec_no_wakeup[] qurik list
Date: Tue,  2 Sep 2025 15:20:25 +0200
Message-ID: <20250902131935.638430927@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9cd51eefae3c871440b93c03716c5398f41bdf78 upstream.

Add the TUXEDO InfinityBook Pro AMD Gen9 to the acpi_ec_no_wakeup[]
quirk list to prevent spurious wakeups.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20250508111625.12149-1-wse@tuxedocomputers.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/ec.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -2329,6 +2329,12 @@ static const struct dmi_system_id acpi_e
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		// TUXEDO InfinityBook Pro AMD Gen9
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "GXxHRXx"),
+		},
+	},
 	{ },
 };
 


