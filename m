Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE25C30DD39;
	Mon, 13 Oct 2025 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369193; cv=none; b=iq604LRvuXs+p4qP54aRBsgOpIyqc+n+OR3rdONwrP1QwgQXwdAKPXhkEXTVP6uj1vizmHZUCDP2z7zzxrburaK6JC99PPG8pV9GxI0wQztdo5wL4CfUwuv9gPKnWO2o97cQWf3uHSNJKeVDsml17zCrEW47bT5ppuFn1EyVC6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369193; c=relaxed/simple;
	bh=e+O9cjkwgBDmGPnZfpp/F6xXI6kcbP5oJnDxy4Ley9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9HBnIkOi7dKq8OVYO5FXGqI5sJXl5huyXAJQx6uwsl/K/THaYYtrvf8v7MTPF7ij9SwVBGxb6VmApO0ckZux08MDE/3GYcb9c18x9EdZYQkTAIIHRgUX5EGTMiEaph4ecb5+SnnwBCBQFjIAYDRCqdDBz2GVHzrP30FECgImvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vItVGPPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vItVGPPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEFFC116B1;
	Mon, 13 Oct 2025 15:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369192;
	bh=e+O9cjkwgBDmGPnZfpp/F6xXI6kcbP5oJnDxy4Ley9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vItVGPPg4MKhu7MG9DL4xiwrv0U6cG8mrJBB6PLdQ1ALCv30HlJw/Kb43DPipMqHD
	 dUki3QT9o5emdwbQ4sDXFP+azm4Iq74ZACujjsZKSh6URr56ITSkym/m6+ha1a8cpb
	 BP7SpT4b7G4nXnU1Gx7otkcK0Oi022y2x/qh//UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Salem <x0rw3ll@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 159/563] ACPICA: Apply ACPI_NONSTRING
Date: Mon, 13 Oct 2025 16:40:20 +0200
Message-ID: <20251013144417.051512981@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Salem <x0rw3ll@gmail.com>

[ Upstream commit 12fd607554c4efb4856959f0e5823f541bc0e701 ]

Add ACPI_NONSTRING for destination char arrays without a terminating NUL
character.

This is a follow-up to commit 2b82118845e0 ("ACPICA: Apply ACPI_NONSTRING")
where a few more destination arrays were missed.

Link: https://github.com/acpica/acpica/commit/f359e5ed
Fixes: 2b82118845e0 ("ACPICA: Apply ACPI_NONSTRING")
Signed-off-by: Ahmed Salem <x0rw3ll@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/actbl.h                                     | 2 +-
 tools/power/acpi/os_specific/service_layers/oslinuxtbl.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 243097a3da636..8a67d4ea6e3fe 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -73,7 +73,7 @@ struct acpi_table_header {
 	char oem_id[ACPI_OEM_ID_SIZE] ACPI_NONSTRING;	/* ASCII OEM identification */
 	char oem_table_id[ACPI_OEM_TABLE_ID_SIZE] ACPI_NONSTRING;	/* ASCII OEM table identification */
 	u32 oem_revision;	/* OEM revision number */
-	char asl_compiler_id[ACPI_NAMESEG_SIZE];	/* ASCII ASL compiler vendor ID */
+	char asl_compiler_id[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;	/* ASCII ASL compiler vendor ID */
 	u32 asl_compiler_revision;	/* ASL compiler version */
 };
 
diff --git a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
index 9741e7503591c..de93067a5da32 100644
--- a/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
+++ b/tools/power/acpi/os_specific/service_layers/oslinuxtbl.c
@@ -995,7 +995,7 @@ static acpi_status osl_list_customized_tables(char *directory)
 {
 	void *table_dir;
 	u32 instance;
-	char temp_name[ACPI_NAMESEG_SIZE];
+	char temp_name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	char *filename;
 	acpi_status status = AE_OK;
 
@@ -1312,7 +1312,7 @@ osl_get_customized_table(char *pathname,
 {
 	void *table_dir;
 	u32 current_instance = 0;
-	char temp_name[ACPI_NAMESEG_SIZE];
+	char temp_name[ACPI_NAMESEG_SIZE] ACPI_NONSTRING;
 	char table_filename[PATH_MAX];
 	char *filename;
 	acpi_status status;
-- 
2.51.0



