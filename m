Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C26229A2;
	Tue, 30 Jul 2024 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354886; cv=none; b=M9TMwt54TowOLag87NE4wsEIwJ5Ziw1nl/LbehnliFP1qvMm01ozkXQeD+t5LNpzSiwEzTB0Yho1JhqSweb+5NYr8atxoD+StLROhcE1aUOW/7irt0jMDr76jJXT+2+JJKjixiPF9quFcZfO9XqLCDGCM2rPy8Q89HN5shESrD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354886; c=relaxed/simple;
	bh=6Qja3WzVJwDtFRE/HJhR2bBuFiMb94/8tBem6jQNHiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0efDFYlU7cSXJjk5l4NcZ3Cpc5n6IS7yRwAqdxiPBNUY613+/kuijrkhGYGqrQ8deK4wZdFx5SwYexQ3CaRO/v4SQIzA6v8MyvdiIUlcfCp01p2Dgx+N5Bl2sLSLi4ayY3SqvsuDIaKL3GuDXAdUu1+2GKoLYkUBkIJiQjMmnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPCJTyYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPCJTyYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334BFC32782;
	Tue, 30 Jul 2024 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354885;
	bh=6Qja3WzVJwDtFRE/HJhR2bBuFiMb94/8tBem6jQNHiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPCJTyYcWVedvNtdoVQ94KzWs6g/8xARQzQo6Ho0gKZRDl3fGuO6azULRWzP3zNUs
	 K/E2BtMCtIooBHL3yNYGs51iNYyvcSL3ySuyJO/jn63gEB0TXFOkDWbuyuA8wm7dIM
	 etF/e2/I4M05JkQPz3EemAC8pUk7rgtqXzStBpmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <groeck@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/568] platform/chrome: cros_ec_debugfs: fix wrong EC message version
Date: Tue, 30 Jul 2024 17:41:53 +0200
Message-ID: <20240730151640.065078880@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit c2a28647bbb4e0894e8824362410f72b06ac57a4 ]

ec_read_version_supported() uses ec_params_get_cmd_versions_v1 but it
wrongly uses message version 0.

Fix it.

Fixes: e86264595225 ("mfd: cros_ec: add debugfs, console log file")
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20240611113110.16955-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/chrome/cros_ec_debugfs.c b/drivers/platform/chrome/cros_ec_debugfs.c
index c876120e0ebc9..793c8c4bf35ba 100644
--- a/drivers/platform/chrome/cros_ec_debugfs.c
+++ b/drivers/platform/chrome/cros_ec_debugfs.c
@@ -329,6 +329,7 @@ static int ec_read_version_supported(struct cros_ec_dev *ec)
 	if (!msg)
 		return 0;
 
+	msg->version = 1;
 	msg->command = EC_CMD_GET_CMD_VERSIONS + ec->cmd_offset;
 	msg->outsize = sizeof(*params);
 	msg->insize = sizeof(*response);
-- 
2.43.0



