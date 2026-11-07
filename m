Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062765;
	b=HMfhYjIZb+U9PgdFgPGBjdwB4Db/GU5G+2nDM2AFiXPLjeqyyXxq+l7or3wqMsOWGFJg
	 oUSD1ks5LeZCwffLAsVPsoTkxB7xixGQeoT6ycVQ9e3RI/izppo3miqCTX+/ShyXOeE4I
	 JS9HMvoEBcnFw9tj02ZPQ7slHk2cabauMVxAzDpzAAZkCG71ZKCShjofKYwKjWjZ3N7Ik
	 oJ+5QLjoehcl/jY4eEuaFOe5+5abvw36QDFqy8HcJ5Pbpt6Ov9s6fwmkCA+GNsZ+uPwYz
	 F2DSgCi6v5xxDa1z0wtUzi7hOKkjaOi4B34a7bwqS/fZxOekaSex8PZQ0yph4N9swfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hzaaf1mFEZpuaba4ClFLQQpPrhOPPIN2pnVL4exUDiM=;
	b=gsTc0Z9tCHE0AGnFZp5MvpjICp/Vayaf1oqtksxtmRfLbhnhWgSLAeCkWc8G37WWqIEU
	 0WKPyWAYOXfxjgVmndf3x2ikOgaBf5VW6cWwZR6F0pyFXqCslmpROooUKHhcr8EA8YZK/
	 AIhCjXCm3hMeiQAaXaBNn7Lh+l3HixKT18LmS5nYu/v1Dd315RdNOJaXWKiOAQlJmvY2k
	 lnBV41eQjVJTVF/sEDJFWWwn45GefffJuM8+6IW0A9W0VysgswWUq1apZ5qFwBPI3RvS2
	 R19unkQ+tvTPk43+wzCgXjijfdZQ7gOj3eZJWCa8vji0r3xb6xe8hDiYts7BZ37Mlbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lnwET/28";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9E0606A32E;
	Sat,  7 Nov 2026 14:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lnwET/28
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776D31F0089F;
	Sat,  7 Nov 2026 14:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062764;
	bh=hzaaf1mFEZpuaba4ClFLQQpPrhOPPIN2pnVL4exUDiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lnwET/28Ba3DFibpYxaZWuTyfrjUrne/jfpQBtgH3cUvvttQd2KObNgc2pE3vEezG
	 97cQwpAk2D7oBDOFH60JxABKUn4St4Zp/nLW7agbvaZy93g/9PpLDhRK+d4aX2eHne
	 GkEzOHQS8yuu7jy7I47Tf/F5sjjVMmt2HFquL5DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/869] thermal: intel: int340x: Fix temperature selection around 0 C
Date: Sat,  7 Nov 2026 08:45:56 -0500
Message-ID: <20261107134855.235764954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e56e2b49c67d132728e52ce493079e83cc914657 ]

Since commit 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to
support negative CPU temperature"), intel_tcc_get_temp() can report
negative temperatures.

proc_thermal_get_zone_temp() still uses *temp as the current maximum and
as an implicit "no reading yet" marker. However, this breaks when a CPU
reports 0 C, because a subsequent negative reading can overwrite it.

Use bool temp_valid to track whether a valid temperature has been read.
Initialize *temp with the first valid reading and only update it with
warmer readings.

Fixes: 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to support negative CPU temperature")
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Thorsten Blum <blum@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260826153144.299746-3-blum@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_device.c   | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index 48e7849d48160..dc9c82e8650e7 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -178,17 +178,21 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 {
 	int cpu;
 	int curr_temp, ret;
-
-	*temp = 0;
+	bool temp_valid = false;
 
 	for_each_online_cpu(cpu) {
 		ret = intel_tcc_get_temp(cpu, &curr_temp, false);
 		if (ret < 0)
 			return ret;
-		if (!*temp || curr_temp > *temp)
+		if (!temp_valid || curr_temp > *temp) {
 			*temp = curr_temp;
+			temp_valid = true;
+		}
 	}
 
+	if (!temp_valid)
+		return -ENODATA;
+
 	*temp *= 1000;
 
 	return 0;
-- 
2.53.0



