Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0855B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81231C433EF;
	Wed, 28 Dec 2022 15:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240181;
	bh=XLnQrrv0n0qLt+falotwTKdhlXBgb5ff7UCWk2stfrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y76mhLjwKSmGwKbaL/+QxiKXwN7rSXYg/A/nArn1psua4I9Q3KEMBXEahPnIKNSz5
	 LRsae/W36uekFCojFg7evvdhDCiJXD1hmzrAcL1tc5P6bd72CCUPz1Rf5tIr9M+FbR
	 JwG+0xWKLUyY0t/04hEPnUExtYwWC4qIkivnZfEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0127/1073] ACPI: pfr_telemetry: use ACPI_FREE() to free acpi_object
Date: Wed, 28 Dec 2022 15:28:35 +0100
Message-Id: <20221228144331.486406860@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 0f2aa7fc2a9aee05bafb965d5b1638d3e74b4c61 ]

acpi_evaluate_dsm_typed()/acpi_evaluate_dsm() should be coupled
with ACPI_FREE() to free the ACPI memory, because we need to
track the allocation of acpi_object when ACPI_DBG_TRACK_ALLOCATIONS
enabled, so use ACPI_FREE() instead of kfree().

Fixes: b0013e037a8b ("ACPI: Introduce Platform Firmware Runtime Telemetry driver")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pfr_telemetry.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pfr_telemetry.c b/drivers/acpi/pfr_telemetry.c
index 9abf350bd7a5..27fb6cdad75f 100644
--- a/drivers/acpi/pfr_telemetry.c
+++ b/drivers/acpi/pfr_telemetry.c
@@ -144,7 +144,7 @@ static int get_pfrt_log_data_info(struct pfrt_log_data_info *data_info,
 	ret = 0;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -180,7 +180,7 @@ static int set_pfrt_log_level(int level, struct pfrt_log_device *pfrt_log_dev)
 		ret = -EBUSY;
 	}
 
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
@@ -218,7 +218,7 @@ static int get_pfrt_log_level(struct pfrt_log_device *pfrt_log_dev)
 	ret = obj->integer.value;
 
 free_acpi_buffer:
-	kfree(out_obj);
+	ACPI_FREE(out_obj);
 
 	return ret;
 }
-- 
2.35.1



