Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829584;
	b=0uGDMF4INnb2mOC4RKoxPtW3mRgbKDjSiQwm4a3sZ2XzYUvdk+3HRWJOciqdGmFvLnwg
	 2Bobn5qQgIvvRVkVS8UWYcdwxioG5Rxeb1qxehL/jH1MVS7ONHSJ/euRZZrASdMhll3BB
	 zgNFE41qsyYQR8s5bQx1YtWAP1DyNW9t9/NBAEepJNqvwTW2+rfy7kBMzs6eIdf+izHUR
	 p5FHS1VeDbbkfFLFE3eNnu5Kf9786z1+JxqZo23IrQFqemP6AzPmd9LX8XCoBwL/2GuMG
	 +IC8CpUbvBlisyD2PSznOA8lm0mBAklsGHl9m7z5XXyNakjMJKygxG1fNeH0fuBbtoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BrR0C8SzOEu4i1Me5gvHSCxyltDwTQ37DK7okYHxaDc=;
	b=vp1i5ywE4f7IrhRWi3rZTlSNKdo+GoWfrv2dd3Ry/58gYMKy05KqNOFmJuHpgoEn1RqM
	 I67/UHKVQmSS5ki02+NGtkFUrA31rdRgzYPqIuENAKqnPGgGumg4OMGi7uWbQ8bBSr5ja
	 huvcPDNsxZj1Z2/Ui7UO6PHeQPYiNAEWtBFWQj/Q/+ueeuQDMbH9vQFZ1DtB3uOSP4EQL
	 WfuSFTXasukb0h9jyceA9q43B+j14r3Kz7a4jGmaztxsrEmXWuKLwq0R7Qeg7pQdPr01E
	 XnCrq/bTWPKWQA5eq1j0pPQvx8DUS87KNY2nqu58UzV+tmKo+2y/bR48pZCpho0WEiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QWo/CJMg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A930D606B399;
	Wed,  4 Nov 2026 21:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QWo/CJMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391611F000C1;
	Wed,  4 Nov 2026 21:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829583;
	bh=BrR0C8SzOEu4i1Me5gvHSCxyltDwTQ37DK7okYHxaDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWo/CJMgp3SkVozHJNX6unfEkUUx+orNYAXMREuC8J3mnJHJH9Q6NrkaDRvNep0+a
	 EBRUWeYf+DWWm/C+G5503JRy3th/MVtrXZijy4ZnWX7lhurriFfIwFa2+WzCAVdI/Q
	 CoU/8EkQvofWDlQZnVJTEt0E4Fx9GYgJsZoIAyaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Renninger <trenn@suse.de>,
	Michal Suchanek <msuchanek@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0215/1005] ACPI: sysfs: Properly map BERT and CCEL data to their ACPI tables
Date: Wed,  4 Nov 2026 15:59:08 -0500
Message-ID: <20261104211049.836750661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Renninger <trenn@suse.de>

[ Upstream commit e45ee607ca6f9f97a2f97be356d844a912971a16 ]

In the case of multiple BERT ACPI tables, one gets:

sysfs: cannot create duplicate filename '/firmware/acpi/tables/data/BERT'

This is because both:

/firmware/acpi/tables/BERT1
/firmware/acpi/tables/BERT2

are attempted to be mapped to the same data table:

/firmware/acpi/tables/data/BERT

Address this problem by passing and using the same filename for data
tables.

Signed-off-by: Thomas Renninger <trenn@suse.de>
Reported-by: Michal Suchanek <msuchanek@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1270211
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260717065129.72924-3-trenn@suse.de
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sysfs.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index e596224302f4c..d8d04437f63d6 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -316,6 +316,7 @@ struct acpi_table_attr {
 struct acpi_data_attr {
 	struct bin_attribute attr;
 	u64	addr;
+	char filename[ACPI_NAMESEG_SIZE+ACPI_INST_SIZE];
 };
 
 static ssize_t acpi_table_show(struct file *filp, struct kobject *kobj,
@@ -453,7 +454,6 @@ static int acpi_bert_data_init(void *th, struct acpi_data_attr *data_attr)
 	}
 	data_attr->addr = bert->address;
 	data_attr->attr.size = bert->region_length;
-	data_attr->attr.attr.name = "BERT";
 
 	return sysfs_create_bin_file(tables_data_kobj, &data_attr->attr);
 }
@@ -469,7 +469,6 @@ static int acpi_ccel_data_init(void *th, struct acpi_data_attr *data_attr)
 	}
 	data_attr->addr = ccel->log_area_start_address;
 	data_attr->attr.size = ccel->log_area_minimum_length;
-	data_attr->attr.attr.name = "CCEL";
 
 	return sysfs_create_bin_file(tables_data_kobj, &data_attr->attr);
 }
@@ -484,7 +483,7 @@ static struct acpi_data_obj {
 
 #define NUM_ACPI_DATA_OBJS ARRAY_SIZE(acpi_data_objs)
 
-static int acpi_table_data_init(struct acpi_table_header *th)
+static int acpi_table_data_init(struct acpi_table_header *th, struct acpi_table_attr *table_attr)
 {
 	struct acpi_data_attr *data_attr;
 	int i;
@@ -497,6 +496,8 @@ static int acpi_table_data_init(struct acpi_table_header *th)
 			sysfs_attr_init(&data_attr->attr.attr);
 			data_attr->attr.read = acpi_data_show;
 			data_attr->attr.attr.mode = 0400;
+			strscpy(data_attr->filename, table_attr->filename);
+			data_attr->attr.attr.name = data_attr->filename;
 			return acpi_data_objs[i].fn(th, data_attr);
 		}
 	}
@@ -543,7 +544,7 @@ static int acpi_tables_sysfs_init(void)
 			return ret;
 		}
 		list_add_tail(&table_attr->node, &acpi_table_attr_list);
-		acpi_table_data_init(table_header);
+		acpi_table_data_init(table_header, table_attr);
 	}
 
 	kobject_uevent(tables_kobj, KOBJ_ADD);
-- 
2.53.0



