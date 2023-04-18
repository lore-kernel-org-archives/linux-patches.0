Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116312572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E3DC433EF;
	Tue, 18 Apr 2023 12:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821559;
	bh=4ObIQEFT28XMyBb0BYjDdLUP28ymPeN1aWYQT7wGy+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLtxEEMIxrqQPHsJS1Z2cCvGusgjt13n4ew9mT5lE6BfNwkVtAnTaHJzF2UCFBnuQ
	 QoN+wg5UbATVAs+Dz5wZ3z8ROYXIpqP0X2PQhccQIRnvO+uncns82HC2Hva2eTG4w/
	 l1L9aTrqiOGMZn0dHaEsKnp6YoTvaPFhvezoiE7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aymeric Wibo <obiwac@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/91] ACPI: resource: Add Medion S17413 to IRQ override quirk
Date: Tue, 18 Apr 2023 14:21:52 +0200
Message-Id: <20230418120307.245380470@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aymeric Wibo <obiwac@gmail.com>

[ Upstream commit 2d0ab14634a26e54f8d6d231b47b7ef233e84599 ]

Add DMI info of the Medion S17413 (board M1xA) to the IRQ override
quirk table. This fixes the keyboard not working on these laptops.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213031
Signed-off-by: Aymeric Wibo <obiwac@gmail.com>
[ rjw: Fixed up white space ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 3b9f894873365..803dc6afa6d69 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -396,6 +396,13 @@ static const struct dmi_system_id medion_laptop[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "M17T"),
 		},
 	},
+	{
+		.ident = "MEDION S17413",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M1xA"),
+		},
+	},
 	{ }
 };
 
-- 
2.39.2



