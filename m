Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D48A183CD9;
	Thu, 13 Feb 2025 15:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460992; cv=none; b=J/PhAgpz65QzVGk6lvLS6eK4hXuAS6q9VE93hemjqcMTTNErSo8tCHzqwBhgb1OBQaIZN6Q/rlLl32pG4yQ/ZxqqQE8otBt+EtKTuu6LCTTaOi2U+Rp2bP0R8NKegiY7Bznz7IzVsc+VD61aH5Vau2y+SUu4KQPF+VvgreAOsY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460992; c=relaxed/simple;
	bh=FzROgoxjeRCf0LHBSt5dS6WzVkXfZ3ESu/FOSwNOCaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=puctX4eZylyVmfo5IUrsSi72mvFeH0JW856qizmIQqJ1q8fVCyGcJnkAj4yLTLR0UzjrjVcCiS+nl9Tb9+ZIcc/I1EeA22k30YBUZ8bo+N4dRQQCR7zirODmjVK+D4R+TabkQDVPHc5NEO/Uw2LeHVLFMDrBEcPBajrqQueBQXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LhNdN5gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LhNdN5gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F55C4CED1;
	Thu, 13 Feb 2025 15:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460991;
	bh=FzROgoxjeRCf0LHBSt5dS6WzVkXfZ3ESu/FOSwNOCaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhNdN5gDuMVxxBLAqZxS0obOooYCE66gMYmXWRCd75nCU8TRAGo6QokX+4R2gcde3
	 PHP5XbheKMWCulshuwGlxDS44QEnLIWbfzET/kw3jfkg3S84obUpV/22CC8DQzsUGs
	 DahQeGQN12nWooc8q8II9t+pc+Zsi2DkfsMVRIVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 269/273] selftests: mptcp: join: fix AF_INET6 variable
Date: Thu, 13 Feb 2025 15:30:41 +0100
Message-ID: <20250213142418.053158503@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

The Fixes commit is a backport renaming a variable, from AF_INET6 to
MPTCP_LIB_AF_INET6.

The commit has been applied without conflicts, except that it missed one
extra variable that was in v6.6, but not in the version linked to the
Fixes commit.

This variable has then been renamed too to avoid these errors:

  LISTENER_CREATED 10.0.2.1:10100     ./mptcp_join.sh: line 2944: [: 2: unary operator expected
  LISTENER_CLOSED  10.0.2.1:10100     ./mptcp_join.sh: line 2944: [: 2: unary operator expected

Fixes: a17d1419126b ("selftests: mptcp: declare event macros in mptcp_lib")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2941,7 +2941,7 @@ verify_listener_events()
 	type=$(mptcp_lib_evts_get_info type "$evt" "$e_type")
 	family=$(mptcp_lib_evts_get_info family "$evt" "$e_type")
 	sport=$(mptcp_lib_evts_get_info sport "$evt" "$e_type")
-	if [ $family ] && [ $family = $AF_INET6 ]; then
+	if [ $family ] && [ $family = $MPTCP_LIB_AF_INET6 ]; then
 		saddr=$(mptcp_lib_evts_get_info saddr6 "$evt" "$e_type")
 	else
 		saddr=$(mptcp_lib_evts_get_info saddr4 "$evt" "$e_type")


