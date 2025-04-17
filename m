Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA90D256C9B;
	Thu, 17 Apr 2025 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915845; cv=none; b=BA2ATPvwcDB7nsDOB01svW5vSA74MSJJ0BU+RqgSK0HUl0/V59e1HWU0BfmT9zTBztYK3BMCphAVlxq3BSCBT2864bRwBe61SnvIy2e1mz7EY+pO+RZCnCPHurisKaodGtfsPgn80JQ0WhUApoHpLIGiK+YyOuJzZV6HjdtrAHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915845; c=relaxed/simple;
	bh=FkQ0pwnbJ/nKIQ+9THFWAyTdokJmpgv5C4UHPuy3cbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbZyWeDjrmZXuRYXDL+g3eIzlKG4JBO4NScX4jicGGOROLqGgFt2kdjo589mjyCAx6I82O0DiY4BxnVijmYfpS1nJAf0TbekztqjoFYnTgojivZ53IEY1p9+VJ4KMlmu9I1p4G0Cfkey/8kt9gHRZeb/8rFQ4Xtf31DzuNZYfqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pttB9FFR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pttB9FFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C1EC4CEE7;
	Thu, 17 Apr 2025 18:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915845;
	bh=FkQ0pwnbJ/nKIQ+9THFWAyTdokJmpgv5C4UHPuy3cbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pttB9FFRy9DAWfdDPVAq5o5/6PgQ5ozpUn+MDw3WrjTl29tbfEZuga9ubSfXIsey7
	 kWYDo//D2evRY4GwRFEZ2wYBLWwEZaZwL+1bpTpw42lidIZS4zqnCr6HHMNzPdhiHa
	 WSuyjiEwCi6pTaogUbsTfOudYCQzukp7PTbD1G1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 219/393] media: i2c: ccs: Set the devices runtime PM status correctly in probe
Date: Thu, 17 Apr 2025 19:50:28 +0200
Message-ID: <20250417175116.393588519@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 80704d14f1bd3628f578510e0a88b66824990ef6 upstream.

Set the device's runtime PM status to suspended in probe error paths where
it was previously set to active.

Fixes: 9447082ae666 ("[media] smiapp: Implement power-on and power-off sequences without runtime PM")
Cc: stable@vger.kernel.org # for >= v5.15
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ccs/ccs-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3562,6 +3562,7 @@ static int ccs_probe(struct i2c_client *
 out_disable_runtime_pm:
 	pm_runtime_put_noidle(&client->dev);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 
 out_cleanup:
 	ccs_cleanup(sensor);


