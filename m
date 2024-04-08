Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6592C7CF29;
	Mon,  8 Apr 2024 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582822; cv=none; b=D9IxFfgMP2N3L7dh5+rLzQFowdnf60AZI/QGqQH0NTxppFAYlXn3VxsAo9Q6sMzt1qPtldfxoMo27YQeKKPVjEvgydlFZZ4JKiJzE+sBR+XGnL64LrMlGlLh/hwhaoXWWg2KJpR6ympXzxCEeDKVWMO6G18ElILgfemJrfXnF90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582822; c=relaxed/simple;
	bh=ITBJNW8ZVfT8fOCIHsVFCiWL/obAe/6xlL0OaTu4o8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipWKaMK4yokqK3FEHl63aeM19mCoQ+Hw9tutSahg6mBDE+QvBavrVmQeO6UWFe2uvUaWFFy/pv38mAqHiQkZO6HJJnqzilCe4irLE4TaSY05S4b7xMsTrM+Z8XT1l8fHPK8Y5boO92PZxgNGUhKFvd3DQserDPOIV+DykcY5GlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ZFUJv3A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ZFUJv3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4165C433C7;
	Mon,  8 Apr 2024 13:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582822;
	bh=ITBJNW8ZVfT8fOCIHsVFCiWL/obAe/6xlL0OaTu4o8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZFUJv3AduDXotlidi+06+PxPAEqHQSNHYELMXXpiwwstRa6DDzjuyMS+/ehg6Q4Q
	 rjCwHVV0ocwF/QCd/WlNyaXEXFORkr3lVV24NCUadcXIZl9SitEkCGhQ6tHK8WVfQZ
	 7nozOem3IHo4jHjjHHLSZyAKF0/vF7SNR9ciV70c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 136/138] selftests: mptcp: display simult in extra_msg
Date: Mon,  8 Apr 2024 14:59:10 +0200
Message-ID: <20240408125300.457750490@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 629b35a225b0d49fbcff3b5c22e3b983c7c7b36f upstream.

Just like displaying "invert" after "Info: ", "simult" should be
displayed too when rm_subflow_nr doesn't match the expect value in
chk_rm_nr():

      syn                                 [ ok ]
      synack                              [ ok ]
      ack                                 [ ok ]
      add                                 [ ok ]
      echo                                [ ok ]
      rm                                  [ ok ]
      rmsf                                [ ok ] 3 in [2:4]
      Info: invert simult

      syn                                 [ ok ]
      synack                              [ ok ]
      ack                                 [ ok ]
      add                                 [ ok ]
      echo                                [ ok ]
      rm                                  [ ok ]
      rmsf                                [ ok ]
      Info: invert

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231025-send-net-next-20231025-v1-10-db8f25f798eb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1771,7 +1771,10 @@ chk_rm_nr()
 		# in case of simult flush, the subflow removal count on each side is
 		# unreliable
 		count=$((count + cnt))
-		[ "$count" != "$rm_subflow_nr" ] && suffix="$count in [$rm_subflow_nr:$((rm_subflow_nr*2))]"
+		if [ "$count" != "$rm_subflow_nr" ]; then
+			suffix="$count in [$rm_subflow_nr:$((rm_subflow_nr*2))]"
+			extra_msg="$extra_msg simult"
+		fi
 		if [ $count -ge "$rm_subflow_nr" ] && \
 		   [ "$count" -le "$((rm_subflow_nr *2 ))" ]; then
 			echo -n "[ ok ] $suffix"


