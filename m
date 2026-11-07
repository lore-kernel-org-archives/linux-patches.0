Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063789;
	b=09GaquRuNIFwj5gsW+LzHw45PncqLf9KMlEy90PkOByVmuudkyXEQH+3m2Bjpjx/9YFL
	 UzrSaz/xRcsOCtVeh1BT1AH6ITJY0/YjjO8pkxLAfzGEY1n9bAKDvmOaKOkjdNEFzMrVK
	 R6u2XqElHLHb7e5XY4FAP9VvwbKlGu3M+tgl3C9WeRqNhXcCHq/ps2x++RHSGbVURElMK
	 jw/JfUcPPL78+TvyYTqle5s8yocKDFUtb/SZge7g0N6KkNiwp5gh/6g9F7CrftImCsx/k
	 iHVkJKTSiL8NlEvVrSEIsKUdrrdl3uKiNCT7H2cY6Fqd6RYj9IR4G2XhToyGJEihYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=42vFk5aO2YlnxM/5+XouMtvB9PxM2x04ky+nE3cBi4M=;
	b=CPUzVvnxTz5AD5bCunT6uqJp/4OMqGkf9KTeIytVQBAv2Fiy8PAK88ZpEULxaodhbuKv
	 +dCJQa2BR4yn1qxc4BjQzT1pilDDq8aZJONOU8u8L44bbYcy7Ldoi5DOySo3rub6S7r9c
	 NQqx6i8S0eVu6aKJl3gTFny4CWI/GMuJimea5m5RoC4a+JWe0Fl5RcQw53ytfKyRZlRU7
	 9bupROPNaPQTgR+2BlcwT0GgTezxfQPfRvS+FAM4hejV76SbQcBH8Ij9h64GyooVj/PnG
	 PBQZ4xvLvVSJdqBWDRd+6AsEsHo0VQ7FCy+ZR9h92HP7aFEmTFY/rRRtBVNVN8LdecQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCL+ecoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00D860A3824;
	Sat,  7 Nov 2026 15:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCL+ecoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C63E1F0089F;
	Sat,  7 Nov 2026 15:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063788;
	bh=42vFk5aO2YlnxM/5+XouMtvB9PxM2x04ky+nE3cBi4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCL+ecoWoabdXqXpZ3nV566U00yar2z6kLWNoRGAGsZzXQptEyDZs1T0bTELJPvIU
	 3pua6T366YpAQYHdeqCpOb5xQEcV1ZonAq+onX1rCmU5rOZfXNrpATPtgT0oBw+QUs
	 Pm94hRN6yC5D2gq0oPxJLohV3z/EC8OpNPC5DoPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Aleksa Sarai <aleksa@amutable.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 851/869] proc: dont let an entry below /proc/<pid>/net be a mountpoint
Date: Sat,  7 Nov 2026 08:58:53 -0500
Message-ID: <20261107134921.647675240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit eeecea75ece2ba894bee4d3c53ed2e40abda8f0e ]

proc_net_d_revalidate() always returns 0 so that a dentry below
/proc/<pid>/net is never reused after setns(). So lookup_fast() will end
up calling d_invalidate(), which unhashes the dentry and detaches every
mount on it, in every mount namespace; including locked mounts.

Then lookup_slow() creates a new dentry for the same entry. So a mount
on /proc/<pid>/net/dev succeeds and goes away with the first lookup of
the name by anybody with search permission on the directory. Given it's
0555 that's everyone's grandma. A mask on such a name hides nothing as
the repro below shows.

Treat those entries like I did fd/, fdinfo/ and map_files/ and refuse to
mount on them in the first place. It's nonsensical theater otherwise:

  procnet net/dev stat

  // SPDX-License-Identifier: GPL-2.0
  /*
   * procnet: cover an entry of /proc/<pid>/ with a bind mount, lock the mount,
   * then look the name up.
   *
   * The first task stays alive, <pid> is its pid. The "container" task has its
   * own mount namespace. There it binds a mask on /proc/<pid>/<name>. It drops to
   * uid 1000 and enters a new user namespace with a new mount namespace, so that
   * the mask is locked. Then one task looks the name up:
   *
   *   stat    the container calls stat() on the name
   *   umount  the container calls umount2(MNT_DETACH) on the name
   *   nobody  a task with uid 65534 in the first namespaces calls stat()
   *
   * The container lists its mounts before and after (that does not look the
   * name up) and then reads the name. MASK is fine. Anything else means that
   * the lookup uncovered the entry.
   *
   * usage: procnet <name> stat|umount|nobody
   *   name "status" is the control, "net/dev" is a file below net, "net/stat" is
   *   a directory below net
   */
  #define _GNU_SOURCE
  #include <dirent.h>
  #include <errno.h>
  #include <fcntl.h>
  #include <sched.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <time.h>
  #include <unistd.h>
  #include <sys/mount.h>
  #include <sys/prctl.h>
  #include <sys/stat.h>
  #include <sys/wait.h>

  #define WORK "/run/pn"

  static char target[128];

  static void die(const char *what)
  {
  	fprintf(stderr, "FATAL %s: %s\n", what, strerror(errno));
  	exit(2);
  }

  static void write_str(const char *path, const char *s, int flags)
  {
  	int fd = open(path, O_WRONLY | flags, 0644);

  	if (fd < 0 || write(fd, s, strlen(s)) < 0)
  		die(path);
  	close(fd);
  }

  /* list the mounts below /proc without a lookup of the target */
  static void mounts(const char *when)
  {
  	char line[512];
  	FILE *f = fopen("/proc/self/mountinfo", "r");
  	int n = 0;

  	if (!f)
  		die("mountinfo");
  	while (fgets(line, sizeof(line), f)) {
  		if (!strstr(line, " /proc/"))
  			continue;
  		printf("container: %s: mount: %s", when, line);
  		n++;
  	}
  	fclose(f);
  	if (!n)
  		printf("container: %s: nothing is mounted below /proc\n", when);
  }

  static void show(const char *when, int isdir)
  {
  	char buf[48] = "";
  	int fd;

  	if (isdir) {
  		struct dirent *de;
  		DIR *d = opendir(target);
  		int hit = 0;

  		if (!d) {
  			printf("container: %s: opendir(%s) = %s\n", when, target, strerror(errno));
  			return;
  		}
  		printf("container: %s: readdir(%s) =", when, target);
  		while ((de = readdir(d))) {
  			if (de->d_name[0] == '.')
  				continue;
  			printf(" %s", de->d_name);
  			hit |= strcmp(de->d_name, "MASK");
  		}
  		closedir(d);
  		printf("%s\n", hit ? "   <-- HIT" : "");
  		return;
  	}
  	fd = open(target, O_RDONLY);
  	if (fd < 0) {
  		printf("container: %s: open(%s) = %s\n", when, target, strerror(errno));
  		return;
  	}
  	if (read(fd, buf, sizeof(buf) - 1) < 0)
  		die("read");
  	close(fd);
  	if (strchr(buf, '\n'))
  		*strchr(buf, '\n') = 0;
  	printf("container: %s: read(%s) = \"%s\"%s\n", when, target, buf,
  	       strncmp(buf, "MASK", 4) ? "   <-- HIT" : "");
  }

  int main(int argc, char **argv)
  {
  	const char *name = argc > 1 ? argv[1] : "net/dev";
  	const char *op = argc > 2 ? argv[2] : "stat";
  	int isdir = !strcmp(name, "net/stat");
  	int to_host[2], to_cont[2];
  	struct stat st;
  	pid_t pid;
  	char c;

  	setvbuf(stdout, NULL, _IOLBF, 0);
  	snprintf(target, sizeof(target), "/proc/%d/%s", getpid(), name);
  	if (unshare(CLONE_NEWNS) || mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
  		die("unshare");
  	mkdir(WORK, 0755);
  	if (mount("W", WORK, "tmpfs", 0, NULL))
  		die("mount W");
  	write_str(WORK "/mask", "MASK", O_CREAT);
  	mkdir(WORK "/maskdir", 0755);
  	write_str(WORK "/maskdir/MASK", "MASK", O_CREAT);
  	if (pipe(to_host) || pipe(to_cont))
  		die("pipe");

  	pid = fork();
  	if (pid < 0)
  		die("fork");
  	if (!pid) {
  		if (unshare(CLONE_NEWNS))
  			die("container unshare");
  		if (mount(isdir ? WORK "/maskdir" : WORK "/mask", target, NULL, MS_BIND, NULL)) {
  			printf("container: bind the mask on %s: %s\n", target, strerror(errno));
  			exit(0);
  		}
  		printf("container: bind the mask on %s: ok\n", target);
  		if (setgid(1000) || setuid(1000) || prctl(PR_SET_DUMPABLE, 1))
  			die("setuid");
  		/* lock the mount: a new user namespace with a copy of the tree */
  		if (unshare(CLONE_NEWUSER | CLONE_NEWNS))
  			die("container userns");
  		write_str("/proc/self/setgroups", "deny", 0);
  		write_str("/proc/self/uid_map", "0 1000 1", 0);
  		write_str("/proc/self/gid_map", "0 1000 1", 0);
  		mounts("before");
  		errno = 0;
  		if (!strcmp(op, "stat")) {
  			stat(target, &st);
  			printf("container: stat(%s): %s\n", target, strerror(errno));
  		} else if (!strcmp(op, "umount")) {
  			umount2(target, MNT_DETACH);
  			printf("container: umount2(%s, MNT_DETACH): %s\n", target, strerror(errno));
  		} else if (write(to_host[1], "g", 1) != 1 || read(to_cont[0], &c, 1) != 1) {
  			die("sync");
  		}
  		mounts("after");
  		show("after", isdir);
  		exit(0);
  	}
  	close(to_host[1]);
  	if (read(to_host[0], &c, 1) == 1) {
  		pid_t p2 = fork();

  		if (!p2) {
  			if (setgid(65534) || setuid(65534))
  				die("setuid");
  			errno = 0;
  			stat(target, &st);
  			printf("nobody: uid %u: stat(%s): %s\n", getuid(), target, strerror(errno));
  			exit(0);
  		}
  		waitpid(p2, NULL, 0);
  		if (write(to_cont[1], "g", 1) != 1)
  			die("sync");
  	}
  	waitpid(pid, NULL, 0);
  	return 0;
  }

Fixes: 1fde6f21d90f ("proc: fix /proc/net/* after setns(2)")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261024-work-procfs-fixes-v1-1-46b03c3a8fac@kernel.org
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Aleksa Sarai <aleksa@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 12b817f4ffcfd..b63f612d5ebf2 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -256,9 +256,10 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
 		inode = proc_get_inode(dir->i_sb, de);
 		if (!inode)
 			return ERR_PTR(-ENOMEM);
+		/* never reused and so never a mountpoint for long */
 		if (de->flags & PROC_ENTRY_FORCE_LOOKUP)
-			return d_splice_alias_ops(inode, dentry,
-						  &proc_net_dentry_ops);
+			return proc_splice_unmountable(inode, dentry,
+						       &proc_net_dentry_ops);
 		return d_splice_alias_ops(inode, dentry,
 					  &proc_misc_dentry_ops);
 	}
-- 
2.53.0



