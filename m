Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF51DE2AE;
	Tue,  8 Oct 2024 13:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392449; cv=none; b=EN2JCmvovSOsgLlLAEgpCJqDALQo7eE9yC8aR9nSjqDJpQm3XhphWxXZdQM0XtrLoI+2vdBjkst6rZ7l3m0PPhjUKVvP8i+1eekauR/V21StaAmALWoeyjYtexvlz7rA1roYP8SH5h+cR4m1NxXk2hmYYzOfw1fWcIZRLKg0Bqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392449; c=relaxed/simple;
	bh=J1EuYZiS36Z3eNRUg3ajDGawVNekgr/X6C/Wm8oIGcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TL9OhRZmmFQaOaHNEQoY0uAilXZYf7QsZYGiV20uUDla4Nwj6SchM3x/WAKRDBEhonD8IOZLTSEcIk9b60VzLtpjEi9Qs/+UI3/HohZR+hjCviGx7KjZ/t5thg49XmztMaMj0zzk5DWVykhnghfl/iCwI3i4H2ZliS9H7nn57zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBo+KUMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBo+KUMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F52CC4CEC7;
	Tue,  8 Oct 2024 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392449;
	bh=J1EuYZiS36Z3eNRUg3ajDGawVNekgr/X6C/Wm8oIGcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBo+KUMgcKWZaBnVrxPNwaHqWo8vDSZjd/g7I6TA53ltzM0i4qktfauP3JG7AZX8A
	 xQENzMcuS2xr3GnxNHNfEeOn5hTdczkzvhXlEUOqq9MyDWSGhBJKFBidB5B65grZQz
	 jRQHNRgNwWJnGOFZbJL6whEwuOFGP4utVPc5vEhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 419/558] scripts/gdb: fix timerlist parsing issue
Date: Tue,  8 Oct 2024 14:07:29 +0200
Message-ID: <20241008115718.763366755@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

commit a633a4b8001a7f2a12584f267a3280990d9ababa upstream.

Patch series "Fix some GDB command error and add some GDB commands", v3.

Fix some GDB command errors and add some useful GDB commands.


This patch (of 5):

Commit 7988e5ae2be7 ("tick: Split nohz and highres features from
nohz_mode") and commit 7988e5ae2be7 ("tick: Split nohz and highres
features from nohz_mode") move 'tick_stopped' and 'nohz_mode' to flags
field which will break the gdb lx-mounts command:

(gdb) lx-timerlist
Python Exception <class 'gdb.error'>: There is no member named nohz_mode.
Error occurred in Python: There is no member named nohz_mode.

(gdb) lx-timerlist
Python Exception <class 'gdb.error'>: There is no member named tick_stopped.
Error occurred in Python: There is no member named tick_stopped.

We move 'tick_stopped' and 'nohz_mode' to flags field instead.

Link: https://lkml.kernel.org/r/20240723064902.124154-1-kuan-ying.lee@canonical.com
Link: https://lkml.kernel.org/r/20240723064902.124154-2-kuan-ying.lee@canonical.com
Fixes: a478ffb2ae23 ("tick: Move individual bit features to debuggable mask accesses")
Fixes: 7988e5ae2be7 ("tick: Split nohz and highres features from nohz_mode")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/timerlist.py |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/scripts/gdb/linux/timerlist.py
+++ b/scripts/gdb/linux/timerlist.py
@@ -87,21 +87,22 @@ def print_cpu(hrtimer_bases, cpu, max_cl
             text += "\n"
 
         if constants.LX_CONFIG_TICK_ONESHOT:
-            fmts = [("  .{}      : {}", 'nohz_mode'),
-                    ("  .{}      : {} nsecs", 'last_tick'),
-                    ("  .{}   : {}", 'tick_stopped'),
-                    ("  .{}   : {}", 'idle_jiffies'),
-                    ("  .{}     : {}", 'idle_calls'),
-                    ("  .{}    : {}", 'idle_sleeps'),
-                    ("  .{} : {} nsecs", 'idle_entrytime'),
-                    ("  .{}  : {} nsecs", 'idle_waketime'),
-                    ("  .{}  : {} nsecs", 'idle_exittime'),
-                    ("  .{} : {} nsecs", 'idle_sleeptime'),
-                    ("  .{}: {} nsecs", 'iowait_sleeptime'),
-                    ("  .{}   : {}", 'last_jiffies'),
-                    ("  .{}     : {}", 'next_timer'),
-                    ("  .{}   : {} nsecs", 'idle_expires')]
-            text += "\n".join([s.format(f, ts[f]) for s, f in fmts])
+            TS_FLAG_STOPPED = 1 << 1
+            TS_FLAG_NOHZ = 1 << 4
+            text += f"  .{'nohz':15s}: {int(bool(ts['flags'] & TS_FLAG_NOHZ))}\n"
+            text += f"  .{'last_tick':15s}: {ts['last_tick']}\n"
+            text += f"  .{'tick_stopped':15s}: {int(bool(ts['flags'] & TS_FLAG_STOPPED))}\n"
+            text += f"  .{'idle_jiffies':15s}: {ts['idle_jiffies']}\n"
+            text += f"  .{'idle_calls':15s}: {ts['idle_calls']}\n"
+            text += f"  .{'idle_sleeps':15s}: {ts['idle_sleeps']}\n"
+            text += f"  .{'idle_entrytime':15s}: {ts['idle_entrytime']} nsecs\n"
+            text += f"  .{'idle_waketime':15s}: {ts['idle_waketime']} nsecs\n"
+            text += f"  .{'idle_exittime':15s}: {ts['idle_exittime']} nsecs\n"
+            text += f"  .{'idle_sleeptime':15s}: {ts['idle_sleeptime']} nsecs\n"
+            text += f"  .{'iowait_sleeptime':15s}: {ts['iowait_sleeptime']} nsecs\n"
+            text += f"  .{'last_jiffies':15s}: {ts['last_jiffies']}\n"
+            text += f"  .{'next_timer':15s}: {ts['next_timer']}\n"
+            text += f"  .{'idle_expires':15s}: {ts['idle_expires']} nsecs\n"
             text += "\njiffies: {}\n".format(jiffies)
 
         text += "\n"


