Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288EE4EB873;
	Thu, 17 Sep 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659444; cv=none; b=uXh0O5C5AzSu+VvRXF3Bzo6dvSNUbcko29+BNjr3WJ3AbdCkomea1CoMXNIPqRMtGJ6l5OGyhDRhlU5QJeivd4++ha7HZqE35y6V3a7qPoAY+t459LYTPr6G3Fs5H4xD1KqwnRNvL37ehSLb+i8GxOylU/toMbo9+TTc4Q3ap3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659444; c=relaxed/simple;
	bh=25H0RqS2Ol45jQyYnHXa2Ydzv3pleS2TowDsr9nb+o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5kQ3aGIPqZWoJlSY7DNKTZ6kQKZNug0llWZ9iZ6T0/G5sCJ0zOIcIf9CHRZJJgtkZLaIprpA/f/mHiXrITWVlgWAL8dvdqxexJVE11qkyGRpYjN5InSpbailmHEp6dDY14sefR9l+B24w2yWyRIvsftqJ0Ixb2z7pu0eLBOE64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2EQLGZh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2EQLGZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E301F000FF;
	Thu, 17 Sep 2026 15:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659439;
	bh=kilfd6afYPJoAr4tLxttgi1OPSBZtt3rCn6EwVO+YFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f2EQLGZhLfuuIFYs6PM9pKPKxS86yNn7l7Jfasf/3cVi1gzqSgas0ztCLmeXyhcHy
	 EhqYpQgUJbJA1znvOuTNJPMluDGzVd7wdnkQfqb6JeygQH9f7q26KesdkxV50Pt0wJ
	 EXVc2KcXoqOI6a6oci4Dtdo1zETOzIKWU/+Fh0mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 258/733] thermal: sysfs: switch to use scnprintf() to suppress truncation warning
Date: Thu, 17 Sep 2026 16:09:26 +0100
Message-ID: <20260917151357.738663853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5ad0af4f4367202b1bc71813052fe39b5116cdb9 ]

Switch the sysfs code to use scnprintf() to avoid warnings about potential
truncation of the names of the sysfs attributes. We can't increase the buffer
size because the size is the part of an ABI for some reason. Note, with
the current size of buffer the affected attributes have a room for up to
1000 names, which ought to be enough for all cases. There is no functional
change, as the same limitation was implied before.

Fixes: c56f5c0342df ("Thermal: Make Thermal trip points writeable")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20260817103324.1020212-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/thermal/thermal_sysfs.c b/drivers/thermal/thermal_sysfs.c
index b44abfc997edf..44bd7c50e4ac2 100644
--- a/drivers/thermal/thermal_sysfs.c
+++ b/drivers/thermal/thermal_sysfs.c
@@ -400,8 +400,8 @@ static int create_trip_attrs(struct thermal_zone_device *tz)
 		struct thermal_trip_attrs *trip_attrs = &td->trip_attrs;
 
 		/* create trip type attribute */
-		snprintf(trip_attrs->type.name, THERMAL_NAME_LENGTH,
-			 "trip_point_%d_type", i);
+		scnprintf(trip_attrs->type.name, sizeof(trip_attrs->type.name),
+			  "trip_point_%d_type", i);
 
 		sysfs_attr_init(&trip_attrs->type.attr.attr);
 		trip_attrs->type.attr.attr.name = trip_attrs->type.name;
@@ -410,8 +410,8 @@ static int create_trip_attrs(struct thermal_zone_device *tz)
 		attrs[i] = &trip_attrs->type.attr.attr;
 
 		/* create trip temp attribute */
-		snprintf(trip_attrs->temp.name, THERMAL_NAME_LENGTH,
-			 "trip_point_%d_temp", i);
+		scnprintf(trip_attrs->temp.name, sizeof(trip_attrs->temp.name),
+			  "trip_point_%d_temp", i);
 
 		sysfs_attr_init(&trip_attrs->temp.attr.attr);
 		trip_attrs->temp.attr.attr.name = trip_attrs->temp.name;
@@ -423,8 +423,8 @@ static int create_trip_attrs(struct thermal_zone_device *tz)
 		}
 		attrs[i + tz->num_trips] = &trip_attrs->temp.attr.attr;
 
-		snprintf(trip_attrs->hyst.name, THERMAL_NAME_LENGTH,
-			 "trip_point_%d_hyst", i);
+		scnprintf(trip_attrs->hyst.name, sizeof(trip_attrs->hyst.name),
+			  "trip_point_%d_hyst", i);
 
 		sysfs_attr_init(&trip_attrs->hyst.attr.attr);
 		trip_attrs->hyst.attr.attr.name = trip_attrs->hyst.name;
-- 
2.53.0



