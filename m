Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9712630E0D3;
	Mon, 13 Oct 2025 15:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370165; cv=none; b=m5irVkDQQX3epSg/Hq5AU4i04lqXPzPrelMNUHNwqrYcVUlB88CwotG9+LRmR2PYid8btdf9Mb0+W1JoXnOZbsD2VdDG0n2EnIRoCxUuQ0sLgenJi21m7N8jUsCoqEgdisFkBkuZnxfYYSAn+BMmX40/I4Kv1A0H8m08OiuuuJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370165; c=relaxed/simple;
	bh=olZ753+H1l/asDudg/gsbaXoVqc4RXMyOZMMxVBxWpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=otoYUIXP37XjFpnVypN5hfTaXK7viesmJg9GmwQYXXkWyj2SaD9ZTp0c8f7zJxIJ4wjFvYpr8dRhD8SXLeqeTOiuIAwwLY41hQx2hW8XQYY+Y1AWZ4wCHscN2tlfHgPSc5CJun1OptJHwxrodJHbwIXcfuFdJyA1WspMSE7+wXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZFFIze7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZFFIze7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3F2C4CEE7;
	Mon, 13 Oct 2025 15:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370165;
	bh=olZ753+H1l/asDudg/gsbaXoVqc4RXMyOZMMxVBxWpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZFFIze7UIRIH5cx3LBtpjVLkNN8MjrxsquQvqbgZ76Jrh0mCvG8ihPjvnydt1F4s
	 GhUOBYR7iJOlivyNFHgRB7eaEheFa1or65nyttYVclU/QspvKziwnfJTjgXJU0vm0M
	 RklxFvAxE0AAs5wYtAEPHJmktFj2UrWi9NJQZ09I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 502/563] ASoC: SOF: ipc3-topology: Fix multi-core and static pipelines tear down
Date: Mon, 13 Oct 2025 16:46:03 +0200
Message-ID: <20251013144429.495774549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

commit 59abe7bc7e7c70e9066b3e46874d1b7e6a13de14 upstream.

In the case of static pipelines, freeing the widgets in the pipelines
that were not suspended after freeing the scheduler widgets results in
errors because the secondary cores are powered off when the scheduler
widgets are freed. Fix this by tearing down the leftover pipelines before
powering off the secondary cores.

Cc: stable@vger.kernel.org
Fixes: d7332c4a4f1a ("ASoC: SOF: ipc3-topology: Fix pipeline tear down logic")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20251002073125.32471-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-topology.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2473,11 +2473,6 @@ static int sof_ipc3_tear_down_all_pipeli
 	if (ret < 0)
 		return ret;
 
-	/* free all the scheduler widgets now */
-	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
-	if (ret < 0)
-		return ret;
-
 	/*
 	 * Tear down all pipelines associated with PCMs that did not get suspended
 	 * and unset the prepare flag so that they can be set up again during resume.
@@ -2493,6 +2488,11 @@ static int sof_ipc3_tear_down_all_pipeli
 		}
 	}
 
+	/* free all the scheduler widgets now. This will also power down the secondary cores */
+	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
+	if (ret < 0)
+		return ret;
+
 	list_for_each_entry(sroute, &sdev->route_list, list)
 		sroute->setup = false;
 


