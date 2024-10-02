Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FE71D0B8C;
	Wed,  2 Oct 2024 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880407; cv=none; b=rKW6gZjTmM/1Fz2SYQOEvr7Vwo1YxZk4YpDrP6S4q9yCe5cSGWfwntCqFV7fkifOEHTQi5UyrhnP43QTkdK1q3DqcggniTcYdvmfZN9oUshxlNB7pMMjHQ2QzZcg7X06ovOL2X7Vg1bLlQaqKhAREr8AUBb0kLBaDiQXDsL6OuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880407; c=relaxed/simple;
	bh=QGeho2CqhOg3KZ9DEptInC7yzmAT4CqXooLnbhQzUfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CLwb2gxDWm0mr4L5l6m9SAcSw1PQPu/tdfrZP3+JdhTpWbgCVdlhn0iEjk6KGa0QsJ+lk97Fjd+JZubMzna89iz88VmEyHIKhU5SYG9XmZF9AUvm9h+PUROxBgceszUkSJMqItx9/2FmEO6xDYCSJ8wrMvBsY11W4DUZYkDjkEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnAvyCKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnAvyCKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D7FC4CEC2;
	Wed,  2 Oct 2024 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880407;
	bh=QGeho2CqhOg3KZ9DEptInC7yzmAT4CqXooLnbhQzUfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BnAvyCKzWo+IRWAzVeu0HARBPV1YOxI6XGfy2pY4j5kY0UOiJEIe4MsDbTZzGH/on
	 hV2GvDaU90RDEGFWCJFqyv/zKLsVYd4ijq0AwJ6BeOs2ZXQlS+5YGFIRmgENUUaorM
	 Pfdp4pxt+DDhIfoO7Duzhi3ReUq/Q8JeJ0ic0qQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 449/538] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Wed,  2 Oct 2024 15:01:28 +0200
Message-ID: <20241002125810.165441073@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,6 +509,12 @@ static const struct dmi_system_id mainge
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


