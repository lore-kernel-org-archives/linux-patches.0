Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3741D04B7;
	Wed,  2 Oct 2024 13:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875716; cv=none; b=Igp1pmD5e+tRcfFOypiO5NAvWQqK3a1n+t9xzkAFaD7ceI5irG2UIHcw3GA6sZV55g5D165Bp2W3TNHxnYOcgr9HgK3rNGTyU+6pTHOejm4F8wo3yTzmDcQw9ssQzSkdBkfOeOgTvZE7/NkX8aX11Fku3Pb9Beb08tAEAMxH5BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875716; c=relaxed/simple;
	bh=Kg3TGJnuL5QEIC44Lch1yauoMn7I9F8P2XzkIddVONI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KynpvYnVQx1FBHVSWnEWBQs8zPJmgHLsa9ZoWL7HGfVd3PsVEkRqoHfMLpkMQwBoRedXprRDq9XwgDYGoAwULYzcTnNMkyeJT7XEIYb4GHweU3vQUhovSU4DGS26tj0PZfjKqm+EHrQZMiQXNSvoKCYa6Ngc2TEqo1W/iqA6QJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hr/VtxmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hr/VtxmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49F1C4CECD;
	Wed,  2 Oct 2024 13:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875716;
	bh=Kg3TGJnuL5QEIC44Lch1yauoMn7I9F8P2XzkIddVONI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hr/VtxmZMurpv547zUIYqyQMSJrPot/C6jLtmumlw3mFhV+4uUATLSDdmphYK2MNw
	 nPR1hFvhhZXJ6QllEfw7UQHCKmOBxC4B1tlJPcobBYTzzHCHHfhmTqXdq4AN4Cq2UW
	 6VjR4p21HPYnRv88z9Pco2N6tcu0/8SSgm4/fEog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 197/695] pmdomain: core: Fix "managed by" alignment in debug summary
Date: Wed,  2 Oct 2024 14:53:15 +0200
Message-ID: <20241002125830.329286679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 987a43e89ec67cc68518c0558db42ba542581597 ]

The "performance" column contains variable-width values.  Hence when
their printed values contain more than one digit, all values in
successive columns become misaligned.

Fix this by formatting it as a fixed-width field.  Adjust successive
spaces and field widths to retain the exiting layout.

Fixes: 0155aaf95a2a ("PM: domains: Add the domain HW-managed mode to the summary")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/e004f9d2a75e9a49c269507bb8a4514001751e85.1725459707.git.geert+renesas@glider.be
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/core.c b/drivers/pmdomain/core.c
index 6691b42eae476..acdc3e7b2eae2 100644
--- a/drivers/pmdomain/core.c
+++ b/drivers/pmdomain/core.c
@@ -3190,7 +3190,7 @@ static void mode_status_str(struct seq_file *s, struct device *dev)
 
 	gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
 
-	seq_printf(s, "%20s", gpd_data->hw_mode ? "HW" : "SW");
+	seq_printf(s, "%9s", gpd_data->hw_mode ? "HW" : "SW");
 }
 
 static void perf_status_str(struct seq_file *s, struct device *dev)
@@ -3198,7 +3198,7 @@ static void perf_status_str(struct seq_file *s, struct device *dev)
 	struct generic_pm_domain_data *gpd_data;
 
 	gpd_data = to_gpd_data(dev->power.subsys_data->domain_data);
-	seq_put_decimal_ull(s, "", gpd_data->performance_state);
+	seq_printf(s, "%-10u  ", gpd_data->performance_state);
 }
 
 static int genpd_summary_one(struct seq_file *s,
-- 
2.43.0



