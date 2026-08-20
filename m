Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C309E44062A;
	Thu, 20 Aug 2026 17:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248267; cv=none; b=f6HMwLoRQNRKj+2lHd6yy0x7bdrsszP+Bu+RfHOxUvA6X54LQQ8H7w6BxtilLvVTqaIC4zXKpHL1AwxNJ0R7ELCdhZX+OVqo1IbC34/EGSWuuFJaFxqVR7PM6ekuH+cP1KmEWE5ExG23YTm11mQnoPmD7y4WjrLPXF8qGiSoPtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248267; c=relaxed/simple;
	bh=qnlnufovsBY+yDVzhZqorOA7PG893VZEP6WsIm0zySs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3ispa3thDeR+FElWJVm+loah0ne6c1rQg6nkZQR53NhCN6y0E2AkzkI272r3leU45LSj2cqZCScKnEp6M6NcVEoTBshEhfLe3r+3XQ7U0DEk/1gqu9U+vx5fxqWVI8BEHg5h0eXRxlaY9xh1V8ITNkzUjhAfOWNJKZZ+xrpVD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2axoYtme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2axoYtme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4CF1F000E9;
	Thu, 20 Aug 2026 17:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248266;
	bh=weLkf7PuabhZPbejjaA0qV8sFedTSWTUy9N3nAyk9RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2axoYtmeKeYFdxKv1EpUVWDFFgRUehHHsLLpD2iSniFW99/EOdKEmevcFOInMeKno
	 BsbvnGKXS/RPCFeTI/qyuAEF2EpkQBAFmO32RdE4MWZHRmI1ejrAqfpY4G2bsnii5Q
	 aYaBvDFOw1Hf6wLsq7bJ45GQ6fzTIPorIDqZgm3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Daniel Bristot de Oliveira <bristot@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/303] tracing: Rename kvfree_rcu() to kvfree_rcu_mightsleep()
Date: Thu, 20 Aug 2026 16:55:04 +0200
Message-ID: <20260820145258.354258098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

[ Upstream commit cae16f2c2e11c60c888715f4d98c12740683d6a2 ]

The kvfree_rcu() macro's single-argument form is deprecated.  Therefore
switch to the new kvfree_rcu_mightsleep() variant. The goal is to
avoid accidental use of the single-argument forms, which can introduce
functionality bugs in atomic contexts and latency bugs in non-atomic
contexts.

Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Stable-dep-of: fe58f457ad8d ("tracing/osnoise: Call synchronize_rcu() when unregistering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 +-
 kernel/trace/trace_probe.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -137,7 +137,7 @@ static void osnoise_unregister_instance(
 	if (!found)
 		return;
 
-	kvfree_rcu(inst);
+	kvfree_rcu_mightsleep(inst);
 }
 
 /*
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1179,7 +1179,7 @@ int trace_probe_remove_file(struct trace
 		return -ENOENT;
 
 	list_del_rcu(&link->list);
-	kvfree_rcu(link);
+	kvfree_rcu_mightsleep(link);
 
 	if (list_empty(&tp->event->files))
 		trace_probe_clear_flag(tp, TP_FLAG_TRACE);


