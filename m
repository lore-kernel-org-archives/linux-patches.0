Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF083A1B6;
	Mon, 14 Oct 2024 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918436; cv=none; b=XP7+BHaMgA3DemyjTuBjbTHK36j4gR00+tzxNMF+kncsDFOS1sCHCUF4Fvc7diU9LvsvEAOYFS43Czlw/y8KJy7YDocmKpyMagp1yNo2GlxvFp2YycnmvtdViWF9O3cZjSFcexv9OiBgW3ldMA5kSmZfbQUX0jGYbNo4j4HZjcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918436; c=relaxed/simple;
	bh=tiMg72K3bSra0yQtuIPecqpbzJfCjaMo5v8F6cmVitk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNsZjYHKD5tB2uVLuR7Z/0KwjWsvQ6QFOMR0zQ2JlXt6ZG6vMDufNvIqDOWiCRxw2MFFGoYG6lGZaCt/TCth5W038BfJsQytpMsoJpEtSJuAJgIaX8dd3hDgrx6QIzs42pjRxZ23V1TUxgQkO5CX5EKZ6QoqZuOF1NkoX5IcfFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlpymNou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlpymNou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF61C4CEC3;
	Mon, 14 Oct 2024 15:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918435;
	bh=tiMg72K3bSra0yQtuIPecqpbzJfCjaMo5v8F6cmVitk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlpymNou70phqrVG5w+ESP8EwJ/INwjtlRmg+kyKPJH4zBD22sm12s9eAfwbTBT9T
	 JsuNnPnOpT+oZ9sT+ai5sgKs6+fPqY0QFedEQZ6iGZsympabPBVkezFgY5xDsETvOy
	 syacS9DBUbrG2DSlXda/aHR5vr1uFHUmTyJ8hQbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 321/798] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Mon, 14 Oct 2024 16:14:35 +0200
Message-ID: <20241014141230.565777461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -513,6 +513,12 @@ static const struct dmi_system_id mainge
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


