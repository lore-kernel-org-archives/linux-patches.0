Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE71A612D7;
	Tue, 20 Feb 2024 21:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463868; cv=none; b=DqZ/MoKGFWHfPOUUR8QBvqCWNEJ+7Y4LfXsFfBmjr+9ArIBBPAw3kOEyJU5eR5Ux75WjZF3ZgHK9qYvEhyKkEtPGzU+rYJVpkhws/kfMtwcu5WkO2nOF/RRMspxAiqrxM1EE4sZHF50K73XhzdbKTuaPLYVqNvxcrvCntWXisws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463868; c=relaxed/simple;
	bh=MOgZcc9hXpRFsc6kxkf01iMRx4PSJ+qp/wslJ6m0RRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5RxhjfaZoldLGkYfizPnp+2NRPYRJRwFi2LmnCLQ4cCdPgtLJUdDh3eXtMMJCdh38BRHM6A4QCATzOMG1cUYopmHBJ/0GkKYTrpdoQJ4CsLO16ONI4LTX7WrJXble1zHh1qf1466WBD4U7naBBvBW62DUxZj9hfh0iCCSKo8hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4pQpXQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4pQpXQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E574C433F1;
	Tue, 20 Feb 2024 21:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463868;
	bh=MOgZcc9hXpRFsc6kxkf01iMRx4PSJ+qp/wslJ6m0RRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B4pQpXQLGdVyajkknkalKCKqUjJmiN2iEgip/b4jAOXCfS/bq6geYHrb+pr73ozVr
	 GTIJVVsnjvHvipFOCa1dTv5ghGCyfReAyXrroEM9mZlC0wUw7jI6tiZxyi37B3Q2TM
	 2QhTpyukKAVmgOQLgxfOV45vg0APDoVZjkn4nVc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 150/331] tracing/synthetic: Fix trace_string() return value
Date: Tue, 20 Feb 2024 21:54:26 +0100
Message-ID: <20240220205642.258357367@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@toblux.com>

commit 9b6326354cf9a41521b79287da3bfab022ae0b6d upstream.

Fix trace_string() by assigning the string length to the return variable
which got lost in commit ddeea494a16f ("tracing/synthetic: Use union
instead of casts") and caused trace_string() to always return 0.

Link: https://lore.kernel.org/linux-trace-kernel/20240214220555.711598-1-thorsten.blum@toblux.com

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: ddeea494a16f ("tracing/synthetic: Use union instead of casts")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_synth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index e7af286af4f1..c82b401a294d 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -441,8 +441,9 @@ static unsigned int trace_string(struct synth_trace_event *entry,
 	if (is_dynamic) {
 		union trace_synth_field *data = &entry->fields[*n_u64];
 
+		len = fetch_store_strlen((unsigned long)str_val);
 		data->as_dynamic.offset = struct_size(entry, fields, event->n_u64) + data_size;
-		data->as_dynamic.len = fetch_store_strlen((unsigned long)str_val);
+		data->as_dynamic.len = len;
 
 		ret = fetch_store_string((unsigned long)str_val, &entry->fields[*n_u64], entry);
 
-- 
2.43.2



