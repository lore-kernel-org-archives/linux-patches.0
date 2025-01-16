Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CDB25A620;
	Thu, 16 Jan 2025 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737071621; cv=none; b=RdVVl+IiX65R7GXVwGGTGbEGe+rirzmz86QHjHg+tCzs1rusvH+nYgLeQ4mqPum0h53e7nJDRkzcZtlKcNgTWcec/dFQf83A8YtAE0mWZ19QWhJLkbsnbythE7V4L07RrHTbhvVHQpBg0EImnFon5KbCAEFFFumkGvwgivjKQ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737071621; c=relaxed/simple;
	bh=92Sxmp65uCbFc9O+1Edqt75ksrte8NO96WmNC9lg5iE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ueUZ4RRWT3s81lz8AMA9S0FjqY8OiwPAvbDQSmxbE2I9jnjnrYfOOsYMPriswhPBQlRRWjW5GVihK28IpNGRzsG6XG+BZODQuJ7/SvtpwZ87OOVGi0gaEY8PxvsuPKGYa9g8JpwP5/3Y4X0NJug0c4r70btXwmEWfoyj/FVF/2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KKD8WV/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KKD8WV/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE54C4CED6;
	Thu, 16 Jan 2025 23:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737071620;
	bh=92Sxmp65uCbFc9O+1Edqt75ksrte8NO96WmNC9lg5iE=;
	h=From:To:Cc:Subject:Date:From;
	b=KKD8WV/Fmb14YESRj+ZOiAvgwBv2Mj2u8yWdAMhdjmnRmHXFpjnf16jNBUVYVfx+n
	 q2fYuv7vrW23VLN9o6gIkzP+hYFkxUS+dQY4HKIcO5FKgOnlRAiDVWwH7ZpLSw7MQK
	 NUW82iMcmaSvkw6DkN+BOjjr+KQSZpLXMfzw38EPI/jQyUOkYeKGKkn79MrIHLGDor
	 AlxSyL1pmRIXpX2ffIsoT283lwt7BiECon1jZ/bhQr14xL3EiJVIFnapFBPm/IYiXE
	 5OFYX7XW38I8Yc++B2Lh6DF8mTUX+A1lUKsKGi3DrWg1IT6qyA4qw9Rjf6B5SdJicu
	 Euc9dGm3HXVcg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/2] SPMI patches for the merge window
Date: Thu, 16 Jan 2025 15:53:36 -0800
Message-ID: <20250116235339.300485-1-sboyd@kernel.org>
X-Mailer: git-send-email 2.48.0.rc2.279.g1de40edade-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have two very small patches this time around, both about firmware
nodes. One plugs a leak and the other sets the fwnode properly for SPMI
devices.

Joe Hattori (1):
  spmi: hisi-spmi-controller: Drop duplicated OF node assignment in
    spmi_controller_probe()

Saravana Kannan (1):
  spmi: Set fwnode for spmi devices

 drivers/spmi/hisi-spmi-controller.c | 3 ---
 drivers/spmi/spmi.c                 | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)


base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

