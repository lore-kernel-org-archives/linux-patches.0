Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8E21E87B;
	Sun,  1 Sep 2024 16:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208505; cv=none; b=lA4EtXcahRkc15+XPVCrAqEPmxib9+EPhu6bsp7/7aYwKv7TEpHV4RBaz4+fAQCmRlDgVctmfmpXQ9W7MYg4l1Nh+PcsZBSxpcEDHQSGIS7eHioT0fZkzfldZzzk6A00FThpoykadK+SpuB007kyHifAIeoaJL/7QhVYlFolEEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208505; c=relaxed/simple;
	bh=BdOy7u3bME4eY4FlTZT011ZxvUWFsws1ofuqu0lyaK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpmxV00lA1Gh4LTeGoqHU55NKlRh3FW9md0zk76b+//u43pABzIU9r47ECtV99HKO565+dV07jOHTUqveSVTnY0Rq+/8ykwWFZSNiwpD4oik5nzIaC3+IaPt9W/MqvjTfemEu2UvvzFr29dpi+R/Y2v1FRrg75D9GOPQ4Dko2kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igFRkFs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igFRkFs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CFD2C4CEC3;
	Sun,  1 Sep 2024 16:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208504;
	bh=BdOy7u3bME4eY4FlTZT011ZxvUWFsws1ofuqu0lyaK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igFRkFs5fjO2H+Ud9ISEuqsMPo8GILq4n2yeWX11l01v69BsEBe2eUD5EGiSGaJGS
	 EbtAk3AmwZFTRe7nxaLecjzMmZh8FVYdmEWyT3/D3kwDL3b5yatYaUQEcYgyzfEUqI
	 pkeWwmISJSSvD/7crQHu/MWwGD6ytcF5qZrykPe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 103/149] selftests: forwarding: local_termination: Down ports on cleanup
Date: Sun,  1 Sep 2024 18:16:54 +0200
Message-ID: <20240901160821.331672513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 65a3cce43d5b4c53cf16b0be1a03991f665a0806 ]

This test neglects to put ports down on cleanup. Fix it.

Fixes: 90b9566aa5cd ("selftests: forwarding: add a test for local_termination.sh")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/bf9b79f45de378f88344d44550f0a5052b386199.1724692132.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/local_termination.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
index 4b364cdf3ef0c..656b1a82d1dca 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -284,6 +284,10 @@ bridge()
 cleanup()
 {
 	pre_cleanup
+
+	ip link set $h2 down
+	ip link set $h1 down
+
 	vrf_cleanup
 }
 
-- 
2.43.0



