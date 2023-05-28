Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44825611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C26C433D2;
	Sun, 28 May 2023 19:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301754;
	bh=UwcGdfQjNMwir3O9UvciyN8LJVzVBjG81GjziT3yCPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFA7+Hd+RyqFtt8c9P0fC8iLf/cg/JFllvbrLPGdk/KDhdz7OX0U3JUbBQHSua0AI
	 wCYBzzJIfcic3FQTZAQuyiMdJQ3FIgzGvRF3PjXpNQ+G7NCs8l0aeAhLG1i3mMURBt
	 Sao34GpTfUYiyggP4nvoYyKTS5qyWVGj6EUgmdO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Moore <robert.moore@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/161] ACPICA: ACPICA: check null return of ACPI_ALLOCATE_ZEROED in acpi_db_display_objects
Date: Sun, 28 May 2023 20:09:07 +0100
Message-Id: <20230528190837.907145509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: void0red <30990023+void0red@users.noreply.github.com>

[ Upstream commit ae5a0eccc85fc960834dd66e3befc2728284b86c ]

ACPICA commit 0d5f467d6a0ba852ea3aad68663cbcbd43300fd4

ACPI_ALLOCATE_ZEROED may fails, object_info might be null and will cause
null pointer dereference later.

Link: https://github.com/acpica/acpica/commit/0d5f467d
Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dbnames.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/dbnames.c b/drivers/acpi/acpica/dbnames.c
index 63fe30e868075..7f14403165dd1 100644
--- a/drivers/acpi/acpica/dbnames.c
+++ b/drivers/acpi/acpica/dbnames.c
@@ -571,6 +571,9 @@ acpi_status acpi_db_display_objects(char *obj_type_arg, char *display_count_arg)
 		object_info =
 		    ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_object_info));
 
+		if (!object_info)
+			return (AE_NO_MEMORY);
+
 		/* Walk the namespace from the root */
 
 		(void)acpi_walk_namespace(ACPI_TYPE_ANY, ACPI_ROOT_OBJECT,
-- 
2.39.2



