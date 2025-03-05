Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11C22528E4;
	Wed,  5 Mar 2025 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198760; cv=none; b=pIhZ1U7WnDuD6WPldjX9I3Z1sbLTfSiGLnAhIo4Ic5fNyrx7HC4UZ1S98Ud5Dqe6xcDaGPnZJHffykaICbayhaTSkCi+5/2a3/bjPZq1wZbgJEY2ZsDBm/Q62EM84vrktoMdaIzMF3p9gbriKtQmK1vJ+V6rgLG3DcNgse6++9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198760; c=relaxed/simple;
	bh=l+sxxI1l4YnmIiSY+R+VF2QSnMXYjhvANKmzs3xnh+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkitv99EVNhhlMZIdQuiTyed2GMF5/5pYlYkltp3KmlheLX7VgDQbqmMyWxoL1Xq0ew01kfzAZ0tYpcD0PyaF/ZZpJGkm6PShnEFcAIlRXyiB1Ca0YDnpntnwP+288uXGSAL+ktwVknigHnQeeMSr+VHt17xijfuqwd+HR/Zg+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1bidmEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1bidmEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CB8C4CED1;
	Wed,  5 Mar 2025 18:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198760;
	bh=l+sxxI1l4YnmIiSY+R+VF2QSnMXYjhvANKmzs3xnh+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1bidmEc2RMdihJhSbSLVh7mwcKo7qIHjDKt08+Rpq5Dx9kT6kOxwfdXvxRVNTquD
	 jg9GkyZJlQVARVVvA6K+cROkiygZRLphMGJYHxoY7CdnOZckA8BQH6rMZzXBB2gTkP
	 L+sAXAAirdfuKxZbg464S5HVd1nb120LHOKALdqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.13 139/157] dm vdo: add missing spin_lock_init
Date: Wed,  5 Mar 2025 18:49:35 +0100
Message-ID: <20250305174510.888161154@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ken Raeburn <raeburn@redhat.com>

commit 36e1b81f599a093ec7477e4593e110104adcfb96 upstream.

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-vdo/dedupe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2178,6 +2178,7 @@ static int initialize_index(struct vdo *
 
 	vdo_set_dedupe_index_timeout_interval(vdo_dedupe_index_timeout_interval);
 	vdo_set_dedupe_index_min_timer_interval(vdo_dedupe_index_min_timer_interval);
+	spin_lock_init(&zones->lock);
 
 	/*
 	 * Since we will save up the timeouts that would have been reported but were ratelimited,


