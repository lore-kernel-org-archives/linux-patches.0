Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41567242D9B;
	Wed, 25 Feb 2026 01:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982876; cv=none; b=jAEGwrk9N48PhHcYxb7kGLEcA9wGiNYbENKMMoHpIVFjl7J0AmGlwrsF1wPn67CK3lQg8RnFHwkShwR5ZGXlzO/M80JVGP7ToKf0ZVYKv2AJrsTXMSMmegE0oWGQ5CfHeKMNBmh1nurcXCDet2vOf0qQa1l+y2lwecAhHp4f1Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982876; c=relaxed/simple;
	bh=OW8opBPZPvHMvw9jbElZHvfhcPUqvGya4KbKLP6hJ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADCACgDi3GcLn/UKNlMlemy+ayxS+xbATBfbtKDcAdR/P7KexSnkd9jlLsMhT8yqyJmHQkwqR1Uz61wJ3RDj9yF6Rh7wRWDa8VuIgpnmQFQEcQSP5Oo+IzFNmLvQbaZhSTl3XvWUEOGZnfreZpXma4gVnpAHx7jKKabRXyDI3IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGPQdV6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGPQdV6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020AEC116D0;
	Wed, 25 Feb 2026 01:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982876;
	bh=OW8opBPZPvHMvw9jbElZHvfhcPUqvGya4KbKLP6hJ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGPQdV6MoYwpiqAOrw4D6ZPFzzeO/xBVJiwrMu2msshM/rvF0kQxbXSgfLteaEnu4
	 Ggrqu2nIAAjWNjPgMOry+0YH69l5fIRMFjNUWYJKEUl22lJsboWTg3EtnsW4UHT+jC
	 QoAj26ZwsC350/XO97PHyrQwCACRUdrhTu9Pdzuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Wu <wusamuel@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 060/781] PM: wakeup: Handle empty list in wakeup_sources_walk_start()
Date: Tue, 24 Feb 2026 17:12:49 -0800
Message-ID: <20260225012401.178061889@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Wu <wusamuel@google.com>

[ Upstream commit 75ce02f4bc9a8b8350b6b1b01872467b0cc960cc ]

In the case of an empty wakeup_sources list, wakeup_sources_walk_start()
will return an invalid but non-NULL address. This also affects wrappers
of the aforementioned function, like for_each_wakeup_source().

Update wakeup_sources_walk_start() to return NULL in case of an empty
list.

Fixes: b4941adb24c0 ("PM: wakeup: Add routine to help fetch wakeup source object.")
Signed-off-by: Samuel Wu <wusamuel@google.com>
[ rjw: Subject and changelog edits ]
Link: https://patch.msgid.link/20260124012133.2451708-2-wusamuel@google.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeup.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 1e1a0e7eeac5f..e69033d16fba0 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -275,9 +275,7 @@ EXPORT_SYMBOL_GPL(wakeup_sources_read_unlock);
  */
 struct wakeup_source *wakeup_sources_walk_start(void)
 {
-	struct list_head *ws_head = &wakeup_sources;
-
-	return list_entry_rcu(ws_head->next, struct wakeup_source, entry);
+	return list_first_or_null_rcu(&wakeup_sources, struct wakeup_source, entry);
 }
 EXPORT_SYMBOL_GPL(wakeup_sources_walk_start);
 
-- 
2.51.0



