Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010D430CB41;
	Wed, 17 Sep 2025 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112720; cv=none; b=FyGO8Sl7O3mIsYviA5LjJAPRXttzKI09lmlc0MNt6gX+4diPXl+fnkzEQx203bcbOKI0Ys9Zo4v4miW0mvpZx1IMFh/bPR4tnxG3ZqoUoEbUiK++YzByKUwJ4Mf6+A8jzKZPX0E8eNOlr2UfBV11M7RjnLz3qPzHM2l1sDI9Zis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112720; c=relaxed/simple;
	bh=9wGb2OKF8v0sPyFpPAc61mZb5TYMhwMtkxAdDUcaRxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQOD4lrExkiHVQEm1q19YsFRH3wLtu4SJJUCkzQcL7LJ8oSeOj9i5eFSFhKriP643roH9k8ofsDyV5/dikWxt4J2sFGzSN4WkHTuqkCJ5vtzoFeBIP5uhSgFb3Mh583hzPoXQQrKj2HHYZUx9XbScK20rSnMrgHgmkVc7ttwojY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHew81U0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHew81U0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428BAC4CEF7;
	Wed, 17 Sep 2025 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112719;
	bh=9wGb2OKF8v0sPyFpPAc61mZb5TYMhwMtkxAdDUcaRxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHew81U0+QdaeBZi0Hae7hI3HqO7SQZOnYrvBU4RF8R1UvDG1CBCJutCmyTy5LQ7P
	 x4SPW0uFxVcBoPKtY/dr9KJNS/4YZJnDUjmbAx1ehvmkfWZy0Nwpen1i+IpSAJw1/2
	 rqBNwmgwfpdtFaOvBF3197BZGr+MLdebi2rv2B1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.16 054/189] doc: mptcp: net.mptcp.pm_type is deprecated
Date: Wed, 17 Sep 2025 14:32:44 +0200
Message-ID: <20250917123353.184685080@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 6f021e95d0828edc8ed104a294594c2f9569383a upstream.

The net.mptcp.pm_type sysctl knob has been deprecated in v6.15,
net.mptcp.path_manager should be used instead.

Adapt the section about path managers to suggest using the new sysctl
knob instead of the deprecated one.

Fixes: 595c26d122d1 ("mptcp: sysctl: set path manager by name")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250908-net-mptcp-misc-fixes-6-17-rc5-v1-2-5f2168a66079@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/mptcp.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/networking/mptcp.rst
+++ b/Documentation/networking/mptcp.rst
@@ -60,10 +60,10 @@ address announcements. Typically, it is
 and the server side that announces additional addresses via the ``ADD_ADDR`` and
 ``REMOVE_ADDR`` options.
 
-Path managers are controlled by the ``net.mptcp.pm_type`` sysctl knob -- see
-mptcp-sysctl.rst. There are two types: the in-kernel one (type ``0``) where the
-same rules are applied for all the connections (see: ``ip mptcp``) ; and the
-userspace one (type ``1``), controlled by a userspace daemon (i.e. `mptcpd
+Path managers are controlled by the ``net.mptcp.path_manager`` sysctl knob --
+see mptcp-sysctl.rst. There are two types: the in-kernel one (``kernel``) where
+the same rules are applied for all the connections (see: ``ip mptcp``) ; and the
+userspace one (``userspace``), controlled by a userspace daemon (i.e. `mptcpd
 <https://mptcpd.mptcp.dev/>`_) where different rules can be applied for each
 connection. The path managers can be controlled via a Netlink API; see
 netlink_spec/mptcp_pm.rst.


