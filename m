Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B333A1F75B6;
	Tue,  3 Dec 2024 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240341; cv=none; b=Q7vhijMNs2aqoolzS1F8YHTK938Se71Zo4kOXj8ZwD2GhmF6/aSzkKuCk2rY+WCbvtDWuXtygKOsPBT1s2HhAZ5ji6z3FV7oAR8pix6p/KCK04qCWaL6mb4dlXm7DqnFKehNfWVAPZqQjqSD4TC52bnt1WTZ7XUuy8xdlPXraCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240341; c=relaxed/simple;
	bh=b/g/SE+hY0qETJU0oA4ooderHt8plLrbZrenvo8NFyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDSDygtKUVpLdGV4tUZdX++jlU0QSmLd6n9dBYX7FgOi2RXRP6kEfhNYo39ZtOJT1HY7jSAo6gYw1WOqPDLgqbyD2gi6cnQ2DIIqQY6WCvgc3AUnV8jNOC6iRYKglLF+JrH4VJZ3yANr7fTgDVMXa1zeaU/XJuMZ2/tQhaKHvPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0xM8czs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0xM8czs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2BDC4CECF;
	Tue,  3 Dec 2024 15:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240341;
	bh=b/g/SE+hY0qETJU0oA4ooderHt8plLrbZrenvo8NFyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0xM8czs8u9wTNC1/SQkyoxD4RC5dnTZOwSjc69ooVXlmfHxKzb7AM1ZEYjp2NZ4r
	 FD53nQhxcPAXsgQYYz/nCcZsbviJJAQ8Vo5X5XN9jKXay0IJPx6H9d8f/cUexLnK53
	 25d37P4iNo7oPJ6n7+YYAHD1sv6kK04DA8qH2S6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/826] thermal: testing: Initialize some variables annoteded with _free()
Date: Tue,  3 Dec 2024 15:36:42 +0100
Message-ID: <20241203144746.397366112@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 0104dcdaad3a7afd141e79a5fb817a92ada910ac ]

Variables annotated with __free() need to be initialized if the function
can return before they get updated for the first time or the attempt to
free the memory pointed to by them upon function return may crash the
kernel.

Fix this issue in some places in the thermal testing code.

Fixes: f6a034f2df42 ("thermal: Introduce a debugfs-based testing facility")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12576267.O9o76ZdvQC@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/testing/zone.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/testing/zone.c b/drivers/thermal/testing/zone.c
index 452c3fa2b2bc5..1f01f49527031 100644
--- a/drivers/thermal/testing/zone.c
+++ b/drivers/thermal/testing/zone.c
@@ -185,7 +185,7 @@ static void tt_add_tz_work_fn(struct work_struct *work)
 int tt_add_tz(void)
 {
 	struct tt_thermal_zone *tt_zone __free(kfree);
-	struct tt_work *tt_work __free(kfree);
+	struct tt_work *tt_work __free(kfree) = NULL;
 	int ret;
 
 	tt_zone = kzalloc(sizeof(*tt_zone), GFP_KERNEL);
@@ -237,7 +237,7 @@ static void tt_zone_unregister_tz(struct tt_thermal_zone *tt_zone)
 
 int tt_del_tz(const char *arg)
 {
-	struct tt_work *tt_work __free(kfree);
+	struct tt_work *tt_work __free(kfree) = NULL;
 	struct tt_thermal_zone *tt_zone, *aux;
 	int ret;
 	int id;
@@ -336,8 +336,8 @@ static void tt_zone_add_trip_work_fn(struct work_struct *work)
 int tt_zone_add_trip(const char *arg)
 {
 	struct tt_thermal_zone *tt_zone __free(put_tt_zone) = NULL;
+	struct tt_trip *tt_trip __free(kfree) = NULL;
 	struct tt_work *tt_work __free(kfree);
-	struct tt_trip *tt_trip __free(kfree);
 	int id;
 
 	tt_work = kzalloc(sizeof(*tt_work), GFP_KERNEL);
@@ -392,7 +392,7 @@ static struct thermal_zone_device_ops tt_zone_ops = {
 
 static int tt_zone_register_tz(struct tt_thermal_zone *tt_zone)
 {
-	struct thermal_trip *trips __free(kfree);
+	struct thermal_trip *trips __free(kfree) = NULL;
 	struct thermal_zone_device *tz;
 	struct tt_trip *tt_trip;
 	int i;
-- 
2.43.0



