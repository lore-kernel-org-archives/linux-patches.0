Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBD41A314B;
	Wed, 19 Feb 2025 09:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957164; cv=none; b=Citui9ufF+cQ5a64rjO3ym724wd4h6VFCeF0pOsM/bgvKYkw55wpvXFIjdIhxvmdnU4FSoaZu20e8uVNAwx3R+WAQI56fMp5TdMns47n40ib1GsTVUB0A5tlFVJJVgxtjjnc1wco5UAkOu1931pz04eudbslsPHSYv3luvzqu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957164; c=relaxed/simple;
	bh=BhHSkcFLWBIU9R10b15Ssu0Wv7sLtuYe9jhfKHtB0xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzw9TKoVep5zsneCRwakBnQrAK6OrtfuDZEWwDcJ9OrlawDvFEyz/8JR36voxvdjzmCzvSV64zd+6qGRdAMVH75bEK2RXKYrAb53OFIz06wCe+qC9U+27h8tcpR4PwglOVQQNvRtpLA7T9cw7nv0+tHaoN+UylQ0NqcNyNTa6lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0FsXk3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0FsXk3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A16C4CED1;
	Wed, 19 Feb 2025 09:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957163;
	bh=BhHSkcFLWBIU9R10b15Ssu0Wv7sLtuYe9jhfKHtB0xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0FsXk3c9o3hDqo3PDJoNxfljaQCnhax/wlPTVawfpSaR9+hZ0/YYwYLpxZT/Mn1R
	 GpVHzs9rBAYFRBnJSrVqWb5linWYES5udQhoFuZ9Fj7miKKSQ/l++yyJLwVgmSJIPk
	 jQ4OXZalbgrlyin73TKCO//UhHXFA8GsvvjJVnDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.1 431/578] i3c: master: Fix missing ret assignment in set_speed()
Date: Wed, 19 Feb 2025 09:27:15 +0100
Message-ID: <20250219082709.967686292@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

commit b266e0d4dac00eecdfaf50ec3f708fd0c3b39637 upstream.

Fix a probe failure in the i3c master driver that occurs when no i3c
devices are connected to the bus.

The issue arises in `i3c_master_bus_init()` where the `ret` value is not
updated after calling `master->ops->set_speed()`. If no devices are
present, `ret` remains set to `I3C_ERROR_M2`, causing the code to
incorrectly proceed to `err_bus_cleanup`.

Cc: stable@vger.kernel.org
Fixes: aef79e189ba2 ("i3c: master: support to adjust first broadcast address speed")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Mukesh Kumar Savaliya <quic_msavaliy@quicinc.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20250108225533.915334-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1861,7 +1861,7 @@ static int i3c_master_bus_init(struct i3
 		goto err_bus_cleanup;
 
 	if (master->ops->set_speed) {
-		master->ops->set_speed(master, I3C_OPEN_DRAIN_NORMAL_SPEED);
+		ret = master->ops->set_speed(master, I3C_OPEN_DRAIN_NORMAL_SPEED);
 		if (ret)
 			goto err_bus_cleanup;
 	}


