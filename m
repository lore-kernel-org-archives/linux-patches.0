Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3D94654F;
	Mon,  1 Apr 2024 16:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989924; cv=none; b=kiSkjlOInrpozZwy8pBQ3+Ox6+6riOGO2cuUNlsK4rJiikbDG3C01FfUuUU7c2n/E0RA8Tfe7Sc1NKCx667uG80aUXnKqgirH0mOhU7dsYOwZ+TEjy+tOmMvKdcvFFQ0D/hjgUDVHjPu7oPpcWfinpoj5/s7/gNuqEDcd6ybxJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989924; c=relaxed/simple;
	bh=4HXrs26/ax+3geqWn+ka30o6lBiD+XrdnlZ7X4zjnv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/G+g73fdn38nx9JMfvl7uaL7TUze6sUfUzbRV2IhUB8npWISOLSjJ+nDYxkl3q8Znx/WEm00Ix+hJ56MVjIK6++l4RPKsJR0/FNGneEJinxJx+kmy2vWwG2GdbwZ27hNkeuMlk0VTKLbeE7GWjRKXmI8eMh4hjo9NyGnxwSFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ELAno/ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ELAno/ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85573C433F1;
	Mon,  1 Apr 2024 16:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989924;
	bh=4HXrs26/ax+3geqWn+ka30o6lBiD+XrdnlZ7X4zjnv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELAno/aeh4EO7xLjnfqkpG9F3HnuA/RD7ZRwXYz1x1dGSIfUB8MMDxfRnJL8ToL1h
	 qetf/njXO2ouuTOZff93A3/UXtxOnJkEgqOuimw3gKcTNYoC78h3BlTDwi76ZSxciz
	 IS2/iWbxS5sQ5dtSvQbldx6wL2hszsPTHdQB8Pf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Audra Mitchell <audra@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 194/396] workqueue: Shorten events_freezable_power_efficient name
Date: Mon,  1 Apr 2024 17:44:03 +0200
Message-ID: <20240401152553.721381795@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Audra Mitchell <audra@redhat.com>

commit 8318d6a6362f5903edb4c904a8dd447e59be4ad1 upstream.

Since we have set the WQ_NAME_LEN to 32, decrease the name of
events_freezable_power_efficient so that it does not trip the name length
warning when the workqueue is created.

Signed-off-by: Audra Mitchell <audra@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7109,7 +7109,7 @@ void __init workqueue_init_early(void)
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
 					      WQ_POWER_EFFICIENT, 0);
-	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_pwr_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||


