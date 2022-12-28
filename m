Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFC41C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F3DC433D2;
	Wed, 28 Dec 2022 16:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245932;
	bh=ZkxL9EC5gdiSeuBMoXXn7hPEESSX2sCMYeJ2MoXdUBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIAwJ2IPM3di3Z5uD2TnAQTaXCgTLbiHSRHV93fzfH+iOhXwMTKe0r8bi2IwbBD/N
	 ID82+t2Grc4ThAkublWU4paTacta06fKADHjgnonxJ4b/PJfIvsS6ONnKrAiyVP8AA
	 kF4VUiiquw+0JJLFMf/4LFHYdxin9VOrsA3Hj2o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhong <floridsleeves@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0949/1146] ACPI: processor: idle: Check acpi_fetch_acpi_dev() return value
Date: Wed, 28 Dec 2022 15:41:28 +0100
Message-Id: <20221228144356.096159479@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Zhong <floridsleeves@gmail.com>

[ Upstream commit 2437513a814b3e93bd02879740a8a06e52e2cf7d ]

The return value of acpi_fetch_acpi_dev() could be NULL, which would
cause a NULL pointer dereference to occur in acpi_device_hid().

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
[ rjw: Subject and changelog edits, added empty line after if () ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index acfabfe07c4f..fc5b5b2c9e81 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1134,6 +1134,9 @@ static int acpi_processor_get_lpi_info(struct acpi_processor *pr)
 	status = acpi_get_parent(handle, &pr_ahandle);
 	while (ACPI_SUCCESS(status)) {
 		d = acpi_fetch_acpi_dev(pr_ahandle);
+		if (!d)
+			break;
+
 		handle = pr_ahandle;
 
 		if (strcmp(acpi_device_hid(d), ACPI_PROCESSOR_CONTAINER_HID))
-- 
2.35.1



