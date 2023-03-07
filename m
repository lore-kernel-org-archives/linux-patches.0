Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9B7BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB40C433EF;
	Tue,  7 Mar 2023 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213699;
	bh=c9U5+zjEEfnJ+GJrBvDYLOqr8/0PM90ddpJhhT8lThQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbJchuyxy2GPNOoVSrx4AmCh8LCLKjIJXyw7VWHxysemA0HrqHzJq9/KEbLI+s6Ej
	 O3N3vCi3n7EzhEcq13Xi2nqKnQQQtQiRc9c6ikgnYNBhcQNTKOniECrG7wR2xRIJEs
	 ogNc69I/K14GaeBS0MBtGWFaLY7tYqgrBfQA20OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 590/885] devlink: Fix TP_STRUCT_entry in trace of devlink health report
Date: Tue,  7 Mar 2023 17:58:44 +0100
Message-Id: <20230307170028.016751977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit d0ab772c1f1558af84f3293a52e9e886e08e0754 ]

Fix a bug in trace point definition for devlink health report, as
TP_STRUCT_entry of reporter_name should get reporter_name and not msg.

Note no fixes tag as this is a harmless bug as both reporter_name and
msg are strings and TP_fast_assign for this entry is correct.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 24969184c5348..77ff7cfc6049a 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -88,7 +88,7 @@ TRACE_EVENT(devlink_health_report,
 		__string(bus_name, devlink_to_dev(devlink)->bus->name)
 		__string(dev_name, dev_name(devlink_to_dev(devlink)))
 		__string(driver_name, devlink_to_dev(devlink)->driver->name)
-		__string(reporter_name, msg)
+		__string(reporter_name, reporter_name)
 		__string(msg, msg)
 	),
 
-- 
2.39.2



