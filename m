Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060766;
	b=5IoocWT11VSe0ahW9pAxyltTCM9NNT+Iw3CDMfY7dQ0JxCtepdvHWDfRkSJbgTJmjIxv
	 Zr+YT677cDy3FqwlMZiyUdK5yIOXkcQAhGV+b9p3oSizC1IrqsxogOJ8O/lyy5Y8tRs9Y
	 l+bwMj7nWls3fzm6DBz7UWwrmXZ3XIsXRgpIiaZlz5QiZSxBPe+OudW+74NX7uoDHcO4V
	 ZW5uHvCuFtS1BfD4gJM/0w/w+IVMAETpKO3Il3FXNaUceTNBhGJgbwgjDEKi8m0tcotqJ
	 HSv3MPgUkIwocJUnZ1r6INMZu93krN+FVTUAkzQp/zU1Z0kSfzMxtjGjTtNHA/L1cEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U5iTFZKTwBlWspfg3ABqQV20uhrHDM0EoEUx2BMueiM=;
	b=RQT2M3knqv0mGRV951M0dXpGUz7pihYxVfYNhwvUNUnZtdWQiwA6yS7KfI3JWeOB7+Ff
	 ZwmTgBk+NI+hKnIeXSDRdZDkI2r5xIaHlFnS/yThIbjbNNgUTKqcNjl/FMZygY8zb6kUY
	 WRi+2z4MJm7Z+T0ktR+FhFJfz4T1Jf0SQVYmO+tGcbV5zhdD5yShKu28s6N0nOzpTHFNZ
	 O3q2hqCxwKJLS+aEzPvzkSvBBYeacBx7hQ43A0dhk9cKjbUUhlWMJoX/lyQrmC0xMa3jL
	 qTLNkA65FwylBMGPUCh+JQSai8P3nEzk0mKnCCTjbxMHLIhL7gZ3kLw0T7ifOox39qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUoSpPcs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A0606A326;
	Sat,  7 Nov 2026 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pUoSpPcs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C12D1F0089F;
	Sat,  7 Nov 2026 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060766;
	bh=U5iTFZKTwBlWspfg3ABqQV20uhrHDM0EoEUx2BMueiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pUoSpPcsuttho4QQOOILUyQDhQRrK/5KQ72aDZRujwag0GV+PmmTA8dlW84HiJsr7
	 rgiCjaOPxV4Z1FIDKxSdbj/xP8aj9kwHEHYlp/uXOdtqO+F/FLjwFUNFZKYPu63f2G
	 +ruj3NE1xFfEeb7M9+wmXowV77aQ14SjMGqpd8Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Renninger <trenn@suse.de>,
	Michal Suchanek <msuchanek@suse.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0178/1536] ACPI: sysfs: Properly map BERT and CCEL data to their ACPI tables
Date: Sat,  7 Nov 2026 08:36:34 -0500
Message-ID: <20261107135002.658596263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 687524b500859..4cedc599263fd 100644
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



