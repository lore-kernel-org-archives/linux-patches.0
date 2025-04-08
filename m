Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6556126561C;
	Tue,  8 Apr 2025 11:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111456; cv=none; b=q1mtQXvBMq69zCkOcf0jc9cqWHxUh4Vpx6awch/v3XL/+kCrqAg7fsXbLt6pxkwvxbprLsCa7MgvptSLjbH5ZL7UjpJY/Jq+i65ERkqiqyvuT9XcfLceaNLCqw/AKWo5lH86pbQiFlmlGKWpR4mRi+wVJNASOh8ebR4H2XJAc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111456; c=relaxed/simple;
	bh=u4d5DT9FQNIlCVsypp6NU2Q5QHLXMIxS1FCFGaK1LQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7tHs3cNon4sh3mesIMHW4409hl/qR6sDnoLKzwkjEwy4R6Ltqggf+mzkLTbXmL5Y6vC5ppKt5EHZNgZumDcJpg2pfYiL4/KgzB82ntyppANovgrQh91Yd0PMaS9ZAmH1Kd+904Jl/o0PW3hAVqVhINbPQpdENvk0UlsKWuZ2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lbZOXIqU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lbZOXIqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB061C4CEE5;
	Tue,  8 Apr 2025 11:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111456;
	bh=u4d5DT9FQNIlCVsypp6NU2Q5QHLXMIxS1FCFGaK1LQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lbZOXIqUVY7UFMfAP7sjdsd3edBp/5rX5hwumNarFlg/2VOqX9IxIzoHnw/Ky6Tfi
	 whY1zEeZguCWeoMj0Sh/1Qe0DFG11RnOqgNAjHWevbDxhq+sG5DRzeRQ6bIfJUVXyu
	 y2KK4FasuaoUY11xcOXi2Av0RbrqcfJY9XrBNJ+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 438/731] usb: typec: thunderbolt: Fix loops that iterate TYPEC_PLUG_SOP_P and TYPEC_PLUG_SOP_PP
Date: Tue,  8 Apr 2025 12:45:35 +0200
Message-ID: <20250408104924.460813000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benson Leung <bleung@chromium.org>

[ Upstream commit b51c1e8d2f49342b2087338c72511326fdb7b172 ]

Fixes these Smatch static checker warnings:
drivers/usb/typec/altmodes/thunderbolt.c:116 tbt_altmode_work() warn: why is zero skipped 'i'
drivers/usb/typec/altmodes/thunderbolt.c:147 tbt_enter_modes_ordered() warn: why is zero skipped 'i'
drivers/usb/typec/altmodes/thunderbolt.c:328 tbt_altmode_remove() warn: why is zero skipped 'i'

Fixes: 100e25738659 ("usb: typec: Add driver for Thunderbolt 3 Alternate Mode")
Signed-off-by: Benson Leung <bleung@chromium.org>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/Z5Psp615abaaId6J@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/altmodes/thunderbolt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/altmodes/thunderbolt.c b/drivers/usb/typec/altmodes/thunderbolt.c
index 1b475b1d98e78..94e47d30e5989 100644
--- a/drivers/usb/typec/altmodes/thunderbolt.c
+++ b/drivers/usb/typec/altmodes/thunderbolt.c
@@ -112,7 +112,7 @@ static void tbt_altmode_work(struct work_struct *work)
 	return;
 
 disable_plugs:
-	for (int i = TYPEC_PLUG_SOP_PP; i > 0; --i) {
+	for (int i = TYPEC_PLUG_SOP_PP; i >= 0; --i) {
 		if (tbt->plug[i])
 			typec_altmode_put_plug(tbt->plug[i]);
 
@@ -143,7 +143,7 @@ static int tbt_enter_modes_ordered(struct typec_altmode *alt)
 	if (tbt->plug[TYPEC_PLUG_SOP_P]) {
 		ret = typec_cable_altmode_enter(alt, TYPEC_PLUG_SOP_P, NULL);
 		if (ret < 0) {
-			for (int i = TYPEC_PLUG_SOP_PP; i > 0; --i) {
+			for (int i = TYPEC_PLUG_SOP_PP; i >= 0; --i) {
 				if (tbt->plug[i])
 					typec_altmode_put_plug(tbt->plug[i]);
 
@@ -324,7 +324,7 @@ static void tbt_altmode_remove(struct typec_altmode *alt)
 {
 	struct tbt_altmode *tbt = typec_altmode_get_drvdata(alt);
 
-	for (int i = TYPEC_PLUG_SOP_PP; i > 0; --i) {
+	for (int i = TYPEC_PLUG_SOP_PP; i >= 0; --i) {
 		if (tbt->plug[i])
 			typec_altmode_put_plug(tbt->plug[i]);
 	}
-- 
2.39.5



