Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113171E1A35;
	Tue, 15 Oct 2024 12:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994155; cv=none; b=MTu822FfGmlNf1ZpyBJv7U5cbNsUdd8onRS0qjvQioQ+hWWJUFTathehoxRv3Dt0tNcnIghKLsViki5SnOuiAlfbpwD45Q9/hCK0qFDhqjXdXiktr+fQgSfVK8vZtqKRx0DtRKlLM/xxWQwJ2E1HtVhO/BLYqjgI5Fdmg5WRcC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994155; c=relaxed/simple;
	bh=1idDyxwHQZohgfraQ8Co6CjR45dKupMbW8WGsQy/Ay8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UgXQoqBvqpK3p7m8V9e6iJv7oMtgVEQF0GwI7aJ+gdCPMbxDfwCwaS/dmnoWANRcdVIhkfYg020GfelllX7P2AEiG2yeXbXKNFys/P2Q8xoSEuxlF26C6nOqo837rWGnvBYrk0cLIyJMM0O8SUoWI263V2oS6McDlfwcepxqZXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEu3lOPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEu3lOPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736FAC4CEC6;
	Tue, 15 Oct 2024 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994154;
	bh=1idDyxwHQZohgfraQ8Co6CjR45dKupMbW8WGsQy/Ay8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEu3lOPyPla1hmjWUQbC9GaEoZqDDHNX/C7NcN1Tf6E7KiuUFjSPPfOtiTYytbkJQ
	 gK/wRv6Qq3tdzkzqCKphzE6Z2UpILrDgxgppp2IuwqIOF8enc3rKAu9+BnlcX/u/rL
	 kZg/idkriX3nj36HzReZKCtu5GmH67fhutt+NNgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 592/691] selftests: net: Remove executable bits from library scripts
Date: Tue, 15 Oct 2024 13:29:00 +0200
Message-ID: <20241015112503.843484993@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 9d851dd4dab63e95c1911a2fa847796d1ec5d58d ]

setup_loopback.sh and net_helper.sh are meant to be sourced from other
scripts, not executed directly. Therefore, remove the executable bits from
those files' permissions.

This change is similar to commit 49078c1b80b6 ("selftests: forwarding:
Remove executable bits from lib.sh")

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Fixes: 3bdd9fd29cb0 ("selftests/net: synchronize udpgro tests' tx and rx connection")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Link: https://lore.kernel.org/r/20240131140848.360618-4-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/net_helper.sh     | 0
 tools/testing/selftests/net/setup_loopback.sh | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 tools/testing/selftests/net/net_helper.sh
 mode change 100755 => 100644 tools/testing/selftests/net/setup_loopback.sh

diff --git a/tools/testing/selftests/net/net_helper.sh b/tools/testing/selftests/net/net_helper.sh
old mode 100755
new mode 100644
diff --git a/tools/testing/selftests/net/setup_loopback.sh b/tools/testing/selftests/net/setup_loopback.sh
old mode 100755
new mode 100644
-- 
2.43.0



