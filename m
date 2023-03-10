Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74AD8825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3E9C4339C;
	Fri, 10 Mar 2023 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460344;
	bh=LifT2ccxy5FWo9Po8YasioVG9xrekmIu1bSPE9O3bwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgeRs91V9zPDP99PhUEDge/G/kBfEydRv5TgXSjcQSvADALgCH+JJraAC+5ajjJ4a
	 ieNmoJBmy95xBh6kK6rIagkKTGDTeua2kWao2iURFpWs7HNNrioiF7wM5LJRWlV7D5
	 pIa/l3Lz5GTaoFuM018zw0WKnQzbfm57YaOenAU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 303/529] ACPI: video: Fix Lenovo Ideapad Z570 DMI match
Date: Fri, 10 Mar 2023 14:37:26 +0100
Message-Id: <20230310133819.042106094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 2d11eae42d52a131f06061015e49dc0f085c5bfc ]

Multiple Ideapad Z570 variants need acpi_backlight=native to force native
use on these pre Windows 8 machines since acpi_video backlight control
does not work here.

The original DMI quirk matches on a product_name of "102434U" but other
variants may have different product_name-s such as e.g. "1024D9U".

Move to checking product_version instead as is more or less standard for
Lenovo DMI quirks for similar reasons.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b13713199ad94..038542b3a80a7 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -313,7 +313,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 .ident = "Lenovo Ideapad Z570",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
-- 
2.39.2



