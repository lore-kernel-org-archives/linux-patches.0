Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210524;
	b=x/qV6Y6r4CjsxKDj5kdYqCQ8QmFw6K6vK2u3LgerB2hhXGdU5ANRUIZRMa+59t/s8H49
	 MNdxpkp6oRNTdf6HA6ue7+36PTgBlSUyVYC0Rcta8OuVflU4jMSVOPQGISlbPfagEsMLt
	 WvpCXVdKFWj1UAr2OVNMD5NcFNBk5QIxwxRSj7dKWscj7dIG6ho7dhtPw7w1oa38FRaOc
	 uLkLnKZgCnkI0vxKRR6npruvH2el/AJCNRkXflAlQvvXpMnfRdr7GtxgGdWGRrE7MGTN0
	 57Fbd1cLukf04TE6DKiW5YorSZ3i/LPVayyIQNzGCytW0YNe0SFHUtdMFaaRiIftF9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u5+kA/9WTRey4pFnpcqhFmD6lkM/R8QE0btA/5DjZVY=;
	b=DX6iHj6sc+lqZlEDvEsdiZLzyQj7JeVY/Hg7toBTlKpa14WNHoCpiq03CGMULuCRGvF1
	 +XUx07zzsFxR6lv0MnuKcqdALG8H34nYDh6oFvS8uXqGO9eZhfeq2YVb7TVtelk+MrX1B
	 zPeQfSpqEPiRfz0MYPE7VRXPcW4zuvqKWt+3baIQ1Q3MvRPFV/nblTON3vpPpVjnukW+e
	 h+QcOh9tz5SBAzXp+zsgCa4LhyC50oJ6VWq1HFcDiTChjvszmwL3jUK8TtVNIu7xjMiBF
	 2gVXnqHED3iXwEXzEmLYDjd+pULZKBYwpZMw/8/Znc/IoqGnWCx1VG2Tpbs6NFAPTIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFq4Rex7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93DD606A336;
	Wed, 28 Oct 2026 18:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFq4Rex7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069D21F031E0;
	Wed, 28 Oct 2026 18:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210523;
	bh=u5+kA/9WTRey4pFnpcqhFmD6lkM/R8QE0btA/5DjZVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFq4Rex7b3cr1QFZVv0yk9hWISyeyKrMX5QDsk+0DqeUweG7xZ3PALTwZF7MO0XNZ
	 YWY+jqLpU4S8RqmvBkIOlCd2vVOauTcSLlyp6UWVmP27F7i9wPPax192LRbYQzkyG8
	 +yJ/wayBQRZiKfh7nUuHgLp2I50MsJydESQZ9W6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/571] coresight: etm3x: Fix cntr_val_show() to match cntr_val_store() behavior
Date: Wed, 28 Oct 2026 17:53:23 +0100
Message-ID: <20261028170009.356850305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit 41fb4e925528aefa4b7a5f76c7f81db99c0d0f38 ]

The cntr_val_show() function was intended to print the values of all
counters using a loop. However, due to a buffer overwrite issue with
sprintf(), it effectively only displayed the value of the last counter.

The companion function, cntr_val_store(), allows users to modify a
specific counter selected by 'cntr_idx'. To maintain consistency
between read and write operations and to align with the ETM4x driver
behavior, modify cntr_val_show() to report only the value of the
currently selected counter.

This change removes the loop and the "counter %d:" prefix, printing
only the hexadecimal value. It also adopts sysfs_emit() for standard
sysfs output formatting.

Fixes: a939fc5a71ad ("coresight-etm: add CoreSight ETM/PTM driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251202082613.3265761-1-visitorckw@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm3x-sysfs.c   | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index e8c7649f123e7..30fae661090fe 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -716,26 +716,19 @@ static DEVICE_ATTR_RW(cntr_rld_event);
 static ssize_t cntr_val_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	int i, ret = 0;
 	u32 val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etm_config *config = &drvdata->config;
 
 	if (!local_read(&drvdata->mode)) {
 		spin_lock(&drvdata->spinlock);
-		for (i = 0; i < drvdata->nr_cntr; i++)
-			ret += sprintf(buf, "counter %d: %x\n",
-				       i, config->cntr_val[i]);
+		val = config->cntr_val[config->cntr_idx];
 		spin_unlock(&drvdata->spinlock);
-		return ret;
-	}
-
-	for (i = 0; i < drvdata->nr_cntr; i++) {
-		val = etm_readl(drvdata, ETMCNTVRn(i));
-		ret += sprintf(buf, "counter %d: %x\n", i, val);
+	} else {
+		val = etm_readl(drvdata, ETMCNTVRn(config->cntr_idx));
 	}
 
-	return ret;
+	return sysfs_emit(buf, "%#x\n", val);
 }
 
 static ssize_t cntr_val_store(struct device *dev,
-- 
2.53.0



