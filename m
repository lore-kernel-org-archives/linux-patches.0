Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E031156C40;
	Mon, 16 Sep 2024 12:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488202; cv=none; b=gy9fYQ6dsIPJjxtNEeJnO7FYMTsDnnD4NcrRwVzt6+V5/QsCXDlzNY6RH2FJs8ZZ9NUnXA4h3qOwtxIPrjMJz+5TUn/dW4f960p/TT5q23Z2bmL4NiHgQ1J9IezpqX0gBINiZQd/pU+RNKKou/pX62YVL/QeSlN94aS1cfLa/4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488202; c=relaxed/simple;
	bh=moz2jlOxlqjBJe4qodW7VTS73qXYocYIhZc89vn3XmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vrhx01zuhLyq+MqpdBeP+4RSbzFZbzpol5v3GmRnaKbgkptbgEHKtlfIRVBg6yZvvlaEC4RySsHG4xepfukcmGYw06BHY4OrWv2micrPLUC6cW6vuU3m6SU+GavGIx5TZkZSERz/yL54UCxjC+kPQtYswvNUxO+YqY8i9gnwvuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3rn1o5C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3rn1o5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFDEC4CEC4;
	Mon, 16 Sep 2024 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488201;
	bh=moz2jlOxlqjBJe4qodW7VTS73qXYocYIhZc89vn3XmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3rn1o5CPxK5SqVqNbOnLK2xHJPBuhS5r2PbNaK7+ywb2QbNsFFFGS7Ny3kl6Uce8
	 SkLepAJSdpheFGdEWMfX37JqA88VBwNn7q8cQTdJYRLkoCAIWjWXpYjt8+Vg2H6hcR
	 9/fN0Snjp3q9VFpwNtcaHxxkMwVQcqLIWVlpQsGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Luz <luzmaximilian@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 030/121] platform/surface: aggregator_registry: Add fan and thermal sensor support for Surface Laptop 5
Date: Mon, 16 Sep 2024 13:43:24 +0200
Message-ID: <20240916114230.029612270@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 002adda09bc1c983c75c82a7e12285c7423aec31 ]

The EC on the Surface Laptop 5 exposes the fan interface. With the
recently introduced driver for it, we can now also enable it here. In
addition, also enable the thermal sensor interface.

Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/20240811131948.261806-5-luzmaximilian@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_aggregator_registry.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/surface_aggregator_registry.c b/drivers/platform/surface/surface_aggregator_registry.c
index 892ba9549f6a..4d3f5b3111ba 100644
--- a/drivers/platform/surface/surface_aggregator_registry.c
+++ b/drivers/platform/surface/surface_aggregator_registry.c
@@ -265,7 +265,9 @@ static const struct software_node *ssam_node_group_sl5[] = {
 	&ssam_node_root,
 	&ssam_node_bat_ac,
 	&ssam_node_bat_main,
-	&ssam_node_tmp_perf_profile,
+	&ssam_node_tmp_perf_profile_with_fan,
+	&ssam_node_tmp_sensors,
+	&ssam_node_fan_speed,
 	&ssam_node_hid_main_keyboard,
 	&ssam_node_hid_main_touchpad,
 	&ssam_node_hid_main_iid5,
-- 
2.43.0



