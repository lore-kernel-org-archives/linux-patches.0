Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7DF1C3E;
	Tue, 23 Jan 2024 01:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972157; cv=none; b=sb3KyOC5tif9H+Z7X6usrCajPWk8IJsdiBNBoLvDOTdNxAFKxfgp26i6rUcC1viKHAkHvS/xWs+QSy5Af5w/0psfzNsr44gaLlDaMhKpwjpS4kiZYAOhk7zWg24xFVF7lalgSBDGmqeaVZ2dwm8lS2jikbTBdkAstnBzKarDz4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972157; c=relaxed/simple;
	bh=8RUJrBxFUVP8j9rW39KeQiguv1jm1bI7/E2MkLonFG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isbZFpgvw/FNYMTvQz7JhdHJi9JpkAuMvSV5zotp9SL+S3UCd5xlUux94tbs4FYnXyIae1E2T2oLPkbtD4HFEGr8WbD4+0PU2D2y23+6kB0z1pRSyhusCjB4mu6t1ldwrrdC86zLufJnjhmMAJY/LkF5m+AaHCUkZsYKTTK2F5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1EbxExq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1EbxExq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE83C43390;
	Tue, 23 Jan 2024 01:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972156;
	bh=8RUJrBxFUVP8j9rW39KeQiguv1jm1bI7/E2MkLonFG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1EbxExqHZG2ywWvvGdrjqhwh+xmjIAUa2lXQtFZ9arKHuZGz8pIdYf31lBzD6Mt9
	 m1QIQzbRf/d5WYDsVqMqeHrvI8lai5IBleAUm+DqZeUOaGoLZVtLU7ZTQkkJA8FZ4v
	 HKGa8Xx8/snx8VWUrKiq2+JGrdCT2SEoiAnMw9WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Acuna <ldacuna@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 050/374] ACPI: resource: Add another DMI match for the TongFang GMxXGxx
Date: Mon, 22 Jan 2024 15:55:06 -0800
Message-ID: <20240122235746.345377357@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit df0cced74159c79e36ce7971f0bf250673296d93 upstream.

The TongFang GMxXGxx, which needs IRQ overriding for the keyboard to work,
is also sold as the Eluktronics RP-15 which does not use the standard
TongFang GMxXGxx DMI board_name.

Add an entry for this laptop to the irq1_edge_low_force_override[] DMI
table to make the internal keyboard functional.

Reported-by: Luis Acuna <ldacuna@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -481,6 +481,13 @@ static const struct dmi_system_id mainge
 		},
 	},
 	{
+		/* TongFang GMxXGxx sold as Eluktronics Inc. RP-15 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Eluktronics Inc."),
+			DMI_MATCH(DMI_BOARD_NAME, "RP-15"),
+		},
+	},
+	{
 		/* TongFang GM6XGxX/TUXEDO Stellaris 16 Gen5 AMD */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "GM6XGxX"),


