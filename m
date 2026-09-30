Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF703D3CEF;
	Wed, 30 Sep 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794240; cv=none; b=au7YHdArO8WJOvpu36fLiGWxrfzhp9jeCMIZzxDcvq78Pd6RcB1w7EJcIy76jP+Svb1D0j7Rt42Hnm+HlE2Dg/D+kx/l4Lcea8nVL5DZ8e38HlzgwKZKTiHEzKAOUvaICU0cJVyyK+8u6U9NiHMYaXUs0mM7lzX1VlcJpyPcFGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794240; c=relaxed/simple;
	bh=R52EnSx+hxGQ+h9HZTwffgCFsalHFYcVZ61sPqc9Sk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d0Be9UH+3EceHzuSYhLWWpXf40cZPzrXHAuZ5idQw/jkJzdMwoKNkyKu7YHnwcmVh/RpXRu17P81tQs/uzSg+22QZIE03U2N2jE1a7W9WXvVad0H7k8+oebGUwyU2BCQdPdd8rrswf8RJvm2Thy23ATGbiqqP+OabpvcNJsAOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3NXVlIN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3NXVlIN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE861F000FF;
	Wed, 30 Sep 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794239;
	bh=n/pX51upYfyRcGjU+6T0R8b8DA+kUTz2QxsPxFGMxiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3NXVlINGoLvEoQBBnzYnfHQOytMNWdgNFbuRxTiOFz513WVWcN8M1ghrzalLJkEM
	 NFzZ7Bc1YG/Fs1OMIA6zAN1NeU7NpBKL2B8KAoBqVFrcz2Z+2ZCq9fd4O0HkbaSEpD
	 mI0VGsXWKeHjhVOneFtK/HBxNEcA8An+hMBphTns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0140/1193] soundwire: only handle alert events when the peripheral is attached
Date: Wed, 30 Sep 2026 17:13:44 +0200
Message-ID: <20260930152437.319542201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 38cd651ebce7065a81c7e950d9e2ea1572304605 ]

It doesn't make sense to handle an alert event when the peripheral is
not attached. The slave->status could be SDW_SLAVE_ATTACHED or
SDW_SLAVE_ALERT when it is attached on the bus.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520025720.1999367-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 50448a4dd0b38..8019d8ffec852 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -1923,6 +1923,10 @@ int sdw_handle_slave_status(struct sdw_bus *bus,
 			break;
 
 		case SDW_SLAVE_ALERT:
+			if (slave->status != SDW_SLAVE_ATTACHED &&
+			    slave->status != SDW_SLAVE_ALERT)
+				continue;
+
 			ret = sdw_handle_slave_alerts(slave);
 			if (ret < 0)
 				dev_err(&slave->dev,
-- 
2.53.0



